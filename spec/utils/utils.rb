# frozen_string_literal: true

def random_elem(list)
  list[Faker::Number.between(0, list.length - 1)]
end

def random_sized_list
  (1..Faker::Number.non_zero_digit.to_i).map { yield }
end
