defmodule Tidetracker.Ingesters.MeetManager7.MeetExport do
  @moduledoc """
  This module is responsible for parsing a Meet Manager 7 export file and turning it into
  a series of changesets that can be used to update the database.
  """

  def ingest(file_path) do
    file_path
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode()
  end
end
