#---
# Excerpted from "Machine Learning in Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/smelixir for more book information.
#---
defmodule BookSearch.Model do
  @moduledoc """
  Manages the BookSearch model for similarity search.
  """

  @hf_model_repo "sentence-transformers/all-MiniLM-L6-v2"

  def predict(text) do
    Nx.Serving.batched_run(BookSearchModel, text)
  end

  def serving(opts \\ []) do
    opts = Keyword.validate!(opts, [
      :defn_options, sequence_length: 64, batch_size: 16
    ])

    sequence_length = opts[:sequence_length] || 64
    batch_size = opts[:batch_size] || 16

    {{model, params}, tokenizer} = load()

    {_init_fun, predict_fun} = Axon.build(model)

    shape = {batch_size, sequence_length}

    Nx.Serving.new(fn defn_options ->
      input_templates = %{
        "input_ids" => Nx.template(shape, :s64),
        "attention_mask" => Nx.template(shape, :s64)
      }

      encoding_fun = Nx.Defn.compile(fn params, inputs ->
        %{pooled_state: out} = predict_fun.(params, inputs)
        out
      end, [params, input_templates], defn_options)

      fn %{size: size} = inputs ->
        inputs = Nx.Batch.pad(inputs, batch_size - size)
        encoding_fun.(params, inputs)
      end
    end, opts[:defn_options])
    |> Nx.Serving.client_preprocessing(
      &preprocess(&1, tokenizer, sequence_length)
    )
  end

  defp load() do
    {:ok, %{model: model, params: params}} = Bumblebee.load_model(
      {:hf, @hf_model_repo}
    )
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, @hf_model_repo})

    {{model, params}, tokenizer}
  end

  defp preprocess(texts, tokenizer, sequence_length) do
    inputs =
      Bumblebee.apply_tokenizer(tokenizer, texts,
        length: sequence_length,
        pad_direction: :right,
        return_token_type_ids: false
      )|> IO.inspect

    {Nx.Batch.concatenate([inputs]), :ok}
  end
end