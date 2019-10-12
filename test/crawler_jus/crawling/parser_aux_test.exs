defmodule CrawlerJus.ParserAuxTest do
  use CrawlerJusWeb.ConnCase
  use ExUnit.Case, async: true

  alias CrawlerJus.{CrawlerEngine, ParserAux}

  describe "check_movimentation_url/1" do
    test "return nil if doesnt recieve a url" do
      assert nil == ParserAux.check_movimentation_url([])
    end

    test "returns nil if url is invalid" do
      url = "#liberarAutoPorSenha"
      assert nil == ParserAux.check_movimentation_url([url])
    end

    test "returns url if its valid" do
      url = "/cpopg/abrirDocumentoVinculadoMovimentacao.do?"
      assert url == ParserAux.check_movimentation_url([url])
    end
  end

  test "word_cleaner_aux/1" do
    word = "Toot\n\n\n\nleeee\t\t\t\tdooooot"
    assert "Tootleeeedooooot" == ParserAux.word_cleaner_aux(word)
  end
end
