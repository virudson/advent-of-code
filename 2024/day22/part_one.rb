# frozen_string_literal: true

def gen_secret_number(secret)
  secret = (secret ^ (secret * 64)) % 16_777_216
  secret = (secret ^ (secret / 32)) % 16_777_216
  (secret ^ (secret * 2048)) % 16_777_216
end

File.read('input.txt').split("\n").sum do
  secret = _1.to_i
  counter = 0
  loop do
    break if counter == 2000

    secret = gen_secret_number(secret)
    counter += 1
  end
  secret
end
