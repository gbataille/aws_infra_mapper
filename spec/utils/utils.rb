# frozen_string_literal: true

def random_elem(list)
  list[Faker::Number.between(0, list.length - 1)]
end
