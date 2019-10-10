defmodule CrawlerJus.ProcessesTest do
  use CrawlerJus.DataCase

  alias CrawlerJus.Processes

  describe "courts" do
    alias CrawlerJus.Processes.Court

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

    test "get_court!/1 returns the court with given id" do
      court = court_fixture()
      assert Processes.get_court!(court.id) == court
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
      assert court == Processes.get_court!(court.id)
    end

    test "delete_court/1 deletes the court" do
      court = court_fixture()
      assert {:ok, %Court{}} = Processes.delete_court(court)
      assert_raise Ecto.NoResultsError, fn -> Processes.get_court!(court.id) end
    end

    test "change_court/1 returns a court changeset" do
      court = court_fixture()
      assert %Ecto.Changeset{} = Processes.change_court(court)
    end
  end

  describe "process_data" do
    alias CrawlerJus.Processes.ProcessData

    @valid_attrs %{data: %{}, process_code: "some process_code"}
    @update_attrs %{data: %{}, process_code: "some updated process_code"}
    @invalid_attrs %{data: nil, process_code: nil}

    def process_data_fixture(attrs \\ %{}) do
      {:ok, process_data} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Processes.create_process_data()

      process_data
    end

    test "list_process_data/0 returns all process_data" do
      process_data = process_data_fixture()
      assert Processes.list_process_data() == [process_data]
    end

    test "get_process_data!/1 returns the process_data with given id" do
      process_data = process_data_fixture()
      assert Processes.get_process_data!(process_data.id) == process_data
    end

    test "create_process_data/1 with valid data creates a process_data" do
      assert {:ok, %ProcessData{} = process_data} = Processes.create_process_data(@valid_attrs)
      assert process_data.data == %{}
      assert process_data.process_code == "some process_code"
    end

    test "create_process_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Processes.create_process_data(@invalid_attrs)
    end

    test "update_process_data/2 with valid data updates the process_data" do
      process_data = process_data_fixture()

      assert {:ok, %ProcessData{} = process_data} =
               Processes.update_process_data(process_data, @update_attrs)

      assert process_data.data == %{}
      assert process_data.process_code == "some updated process_code"
    end

    test "update_process_data/2 with invalid data returns error changeset" do
      process_data = process_data_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Processes.update_process_data(process_data, @invalid_attrs)

      assert process_data == Processes.get_process_data!(process_data.id)
    end

    test "delete_process_data/1 deletes the process_data" do
      process_data = process_data_fixture()
      assert {:ok, %ProcessData{}} = Processes.delete_process_data(process_data)
      assert_raise Ecto.NoResultsError, fn -> Processes.get_process_data!(process_data.id) end
    end

    test "change_process_data/1 returns a process_data changeset" do
      process_data = process_data_fixture()
      assert %Ecto.Changeset{} = Processes.change_process_data(process_data)
    end
  end
end
