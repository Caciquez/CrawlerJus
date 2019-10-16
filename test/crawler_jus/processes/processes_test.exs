defmodule CrawlerJus.ProcessesTest do
  use CrawlerJus.DataCase

  alias CrawlerJus.Processes
  alias CrawlerJus.Processes.{Court, ProcessData}

  describe "courts" do
    @valid_attrs %{
      name: "some name",
      name_abbreviation: "some name_abbreviation",
      url: "some url"
    }
    @update_attrs %{
      name: "some updated name",
      name_abbreviation: "some updated name_abbreviation",
      url: "some updated url"
    }
    @invalid_attrs %{name: nil, name_abbreviation: nil, url: nil}

    def court_fixture(attrs \\ %{}) do
      {:ok, court} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Processes.create_court()

      court
    end

    test "list_courts/0 returns all courts" do
      court = court_fixture()
      assert Processes.list_courts() == [court]
    end

    test "get_court/1 returns the court with given id" do
      court = court_fixture()
      assert Processes.get_court(court.id) == court
    end

    test "create_court/1 with valid data creates a court" do
      assert {:ok, %Court{} = court} = Processes.create_court(@valid_attrs)
      assert court.name == "some name"
      assert court.name_abbreviation == "some name_abbreviation"
      assert court.url == "some url"
    end

    test "create_court/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Processes.create_court(@invalid_attrs)
    end

    test "update_court/2 with valid data updates the court" do
      court = court_fixture()
      assert {:ok, %Court{} = court} = Processes.update_court(court, @update_attrs)
      assert court.name == "some updated name"
      assert court.name_abbreviation == "some updated name_abbreviation"
      assert court.url == "some updated url"
    end

    test "update_court/2 with invalid data returns error changeset" do
      court = court_fixture()
      assert {:error, %Ecto.Changeset{}} = Processes.update_court(court, @invalid_attrs)
      assert court == Processes.get_court(court.id)
    end

    test "delete_court/1 deletes the court" do
      court = court_fixture()
      assert {:ok, %Court{}} = Processes.delete_court(court)
      assert nil == Processes.get_court(court.id)
    end

    test "change_court/1 returns a court changeset" do
      court = court_fixture()
      assert %Ecto.Changeset{} = Processes.change_court(court)
    end
  end

  describe "process_data" do
    @update_attrs %{data: %{}, process_code: "some updated process_code"}
    @invalid_attrs %{data: nil, process_code: nil}

    test "list_process_data/0 returns all process_data" do
      process_data1 = insert(:process_data)
      process_data2 = insert(:process_data)

      [process1 | [process2]] = Processes.list_process_data()

      assert process_data1.process_code == process1.process_code
      assert process_data1.data == process1.data

      assert process_data2.process_code == process2.process_code
      assert process_data2.data == process2.data
    end

    test "get_process_data!/1 returns the process_data with given id" do
      process_data = insert(:process_data)

      assert Processes.get_process_data!(process_data.id).id == process_data.id
    end

    test "get_process_data_by_process_code/1 returns the process_data with given process_code" do
      process_data = insert(:process_data)

      assert Processes.get_process_data_by_process_code(process_data.process_code).id ==
               process_data.id
    end

    test "create_process_data/1 with valid data creates a process_data" do
      court = insert(:court)

      valid_attrs = %{
        data: %{"le_processito" => "su_valorzito"},
        process_code: "some process_code",
        court_id: court.id
      }

      assert {:ok, %ProcessData{} = process_data} = Processes.create_process_data(valid_attrs)
      assert process_data.data == valid_attrs.data
      assert process_data.process_code == valid_attrs.process_code
    end

    test "create_process_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Processes.create_process_data(@invalid_attrs)
    end

    test "update_process_data/2 with valid data updates the process_data" do
      process_data = insert(:process_data)

      assert {:ok, %ProcessData{} = process_data} =
               Processes.update_process_data(process_data, @update_attrs)

      assert process_data.data == %{}
      assert process_data.process_code == "some updated process_code"
    end

    test "update_process_data/2 with invalid data returns error changeset" do
      process_data = insert(:process_data)

      assert {:error, %Ecto.Changeset{}} =
               Processes.update_process_data(process_data, @invalid_attrs)

      non_updated_process_data = Processes.get_process_data!(process_data.id)
      assert process_data.data == non_updated_process_data.data
      assert process_data.process_code == non_updated_process_data.process_code
    end

    test "delete_process_data/1 deletes the process_data" do
      process_data = insert(:process_data)
      assert {:ok, %ProcessData{}} = Processes.delete_process_data(process_data)
      assert_raise Ecto.NoResultsError, fn -> Processes.get_process_data!(process_data.id) end
    end

    test "change_process_data/1 returns a process_data changeset" do
      process_data = insert(:process_data)
      assert %Ecto.Changeset{} = Processes.change_process_data(process_data)
    end
  end

  describe "create_or_update_process_data/3" do
    test "inserts process_data if one with process_code doesnt exist" do
      court = insert(:court)
      process_code = "0067154-55.2010.8.02.0001"

      process_data_params = %{
        "action_value" => "R$ 510,00",
        "area" => "Cível",
        "class" => "Ação Civil Pública",
        "data_distribition" => "29/09/2010 às 15:57 - Sorteio",
        "judge" => "Antonio Emanuel Dória Ferreira",
        "movimentations_list" => [
          %{
            "data" => "15/09/2017",
            "moviment" => "Baixa Definitiva",
            "moviment_url" => "/url/com/dados/do/processo"
          },
          %{
            "data" => "05/07/2016",
            "moviment" => "Baixa definitiva",
            "moviment_url" => "/url/com/dados/do/processo"
          }
        ],
        "parts" => %{
          " Defensor" => "Defensor",
          " Procurador" => "Município de Maceió"
        },
        "subject_matter" => "Tratamento Médico-Hospitalar e/ou Fornecimento de Medicamentos"
      }

      assert {:ok, %ProcessData{} = process_data} =
               Processes.create_or_update_process_data(
                 process_code,
                 process_data_params,
                 court.id
               )
    end

    test "update process_data when process_code already exists" do
      court = insert(:court)
      existing_process_data = insert(:process_data)

      process_data_params = %{
        "action_value" => "R$ 1000,00",
        "area" => "Penal",
        "class" => "Ação Penal Pública",
        "data_distribition" => "30/09/2019 às 15:57 - Sorteio",
        "judge" => "John The Monster",
        "movimentations_list" => [
          %{
            "data" => "15/09/2017",
            "moviment" => "Baixa Definitiva",
            "moviment_url" => "/url/com/dados/do/processo"
          }
        ],
        "parts" => %{
          " Defensor" => "Defensor",
          " Procurador" => "Município de Alagoas"
        },
        "subject_matter" => "Prisão Domiciliar"
      }

      assert {:ok, %ProcessData{} = process_data} =
               Processes.create_or_update_process_data(
                 existing_process_data.process_code,
                 process_data_params,
                 court.id
               )

      assert process_data.data == process_data_params
      assert process_data.process_code == existing_process_data.process_code
    end
  end
end
