defmodule CrawlerJus.ParserAuxTest do
  use CrawlerJusWeb.ConnCase
  use ExUnit.Case, async: true

  alias CrawlerJus.ParserAux

  describe "extract_parts_names/1" do
    test "returns only existing part names when doesnt find #tableTodasPartes" do
      html = File.read!("test/html_fixtures/principal_table.html.eex")

      assert CrawlerJus.ParserAux.extract_parts_names(html) == [
               "Vanusa Maria da Conceição",
               "Dr. Sebastião Bezerra Leite"
             ]
    end

    test "return all existing part names when finds #tableTodasPartes" do
      html = File.read!("test/html_fixtures/full_table.html.eex")

      assert CrawlerJus.ParserAux.extract_parts_names(html) == [
               "José Carlos Alves de Farias Filho",
               "Hanna Gabriela Cardoso Nunes Ferreira ",
               "Giane Aguiar Cardoso ",
               "Losango Promoções de vendas Ltda",
               "SIMONE ALVES DA SLVA ",
               "HSBC SEGUROS (BRASIL) S/A",
               "DIOGO DANTAS DE MOARES FURTADO ",
               "Renata Trigueiro Freitas"
             ]
    end
  end

  describe "extract_roles_names/1" do
    test "returns only existing roles names when doesnt find #tableTodasPartes" do
      html = File.read!("test/html_fixtures/principal_table.html.eex")
      assert CrawlerJus.ParserAux.extract_roles_names(html) == ["Requerente", " Advogado"]
    end

    test "returns all roles names when doesnt find #tableTodasPartes" do
      html = File.read!("test/html_fixtures/full_table.html.eex")

      assert CrawlerJus.ParserAux.extract_roles_names(html) == [
               "Demandante",
               " Advogado",
               " Advogado",
               " Demandado",
               " Advogado",
               " Demandado",
               " Advogado",
               " Advogado"
             ]
    end
  end

  test "extract_moviment_date/1" do
    html = File.read!("test/html_fixtures/moviments_table.html.eex")

    assert CrawlerJus.ParserAux.extract_moviment_date(html) =~
             "09/06/2017"
  end

  test "extract_moviment_content/1" do
    html = File.read!("test/html_fixtures/moviments_table.html.eex")

    assert CrawlerJus.ParserAux.extract_moviment_content(html) =~
             "Arquivado Definitivamente       Certidão              Certidão Arquivamento"
  end

  test "word_cleaner_aux/1" do
    word = "Toot\n\n\n\nleeee\t\t\t\tdooooot"
    assert "Tootleeeedooooot" == ParserAux.word_cleaner_aux(word)
  end
end
