{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()
Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(CrawlerJus.Repo, :manual)

Mox.defmock(CrawlerJus.RedisCacheMock, for: CrawlerJus.RedisCache)

Application.ensure_all_started(:mox)
