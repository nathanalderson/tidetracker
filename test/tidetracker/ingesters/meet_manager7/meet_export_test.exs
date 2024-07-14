defmodule Tidetracker.Ingesters.MeetManager7.MeetExportTest do
  use Tidetracker.DataCase, async?: false
  alias Tidetracker.Ingesters.MeetManager7.MeetExport

  @fixture_path Path.join([__DIR__, "..", "..", "fixtures"])

  describe "ingest" do
    test "non-existent file raises" do
      file_path = "non-existent.csv"

      assert_raise(File.Error, fn ->
        MeetExport.ingest(file_path) |> Enum.take(1)
      end)
    end

    test "ingests a Meet Manager 7 file" do
      file_path = Path.join([@fixture_path, "time-trials-2024-results.csv"])
      [{:ok, row1}] = MeetExport.ingest(file_path) |> Enum.take(1)
      assert is_list(row1)
    end
  end
end
