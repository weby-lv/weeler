FactoryBot.define do
 factory :dummy_post, class: Post do
    title { "Foo bar" }
    body { "Foo baar bazaar" }
  end
end
