# frozen_string_literal: true

def gen_secret_number(secret)
  secret = (secret ^ (secret * 64)) % 16_777_216
  secret = (secret ^ (secret / 32)) % 16_777_216
  (secret ^ (secret * 2048)) % 16_777_216
end

all_cycle = File.read('input.txt').split("\n").each_with_object({}) do |num, hash|
  secret = num.to_i
  counter = 0
  change_list = []
  price = secret % 10

  loop do
    break if counter == 2000

    secret = gen_secret_number(secret)
    counter += 1

    change_list.shift if change_list.size == 4
    change_list << ((secret % 10) - price)
    price = secret % 10

    if change_list.size == 4
      list = change_list.clone
      hash[list] ||= {}
      hash[list][num] ||= price
    end
  end
end

all_cycle.values.map { _1.values.sum }.max

