defmodule AutoApi.MaintenanceStateTest do
  use ExUnit.Case
  alias AutoApi.MaintenanceState

  test "to_bin/1 & from_bin/1" do
    state =
      %MaintenanceState{}
      |> MaintenanceState.put_property(
        :next_inspection_date,
        DateTime.truncate(DateTime.utc_now(), :millisecond)
      )

    new_state =
      state
      |> MaintenanceState.to_bin()
      |> MaintenanceState.from_bin()

    assert state == new_state
  end
end
