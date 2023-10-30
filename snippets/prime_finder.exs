defmodule PrimeFinder do
  def is_prime?(n, divisor \\ 2)

  def is_prime?(2, _divisor), do: true
  def is_prime?(n, divisor) when divisor * divisor > n, do: true

  def is_prime?(n, divisor) do
    if rem(n, divisor) == 0, do: false, else: is_prime?(n, divisor + 1)
  end

  def print_primes(n) when n <= 0, do: IO.puts("Please enter a positive number.")

  def print_primes(n) do
    print_primes(n, 2, 0)
  end

  defp print_primes(0, _current, _count), do: :ok

  defp print_primes(n, current, count) do
    if is_prime?(current) do
      IO.puts("#{count + 1}: #{current}")
      print_primes(n - 1, current + 1, count + 1)
    else
      print_primes(n, current + 1, count)
    end
  end

  def largest_n_digit_prime(digits) when digits <= 0 do
    IO.puts("Please enter a positive number of digits.")
  end

  def largest_n_digit_prime(digits) do
    start = :math.pow(10, digits) |> trunc()
    start = start - 1
    find_prime_below(start)
  end

  defp find_prime_below(n) when n <= 1, do: nil

  defp find_prime_below(n) do
    if is_prime?(n),
      # do: IO.puts("The largest prime with that many digits is: #{n}"),
      else: find_prime_below(n - 1)
  end
end

# Change the number in the function call below to get the desired number of primes
IO.puts("The first 10 primes are:")
PrimeFinder.print_primes(10)

digits = 4
IO.puts("The largest prime with #{digits} digits is:")
PrimeFinder.largest_n_digit_prime(3)
