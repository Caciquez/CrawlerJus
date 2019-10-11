defmodule CrawlerJus.CourtFactory do
  defmacro __using__(_opts) do
    alias Faker.StarWars

    quote do
      def court_factory do
        %CrawlerJus.Processes.Court{
          name: StarWars.character(),
          name_abbreviation: "TJAL",
          url: "We change stuff thats how we do it."
        }
      end
    end
  end
end
