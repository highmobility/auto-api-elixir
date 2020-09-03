defmodule AutoApi.MaintenanceStateTest do
  use ExUnit.Case
  alias AutoApi.MaintenanceState

  describe "to_bin/1 & from_bin/1" do
    test "simple property" do
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

    test "complex property" do
      state =
        %MaintenanceState{}
        |> MaintenanceState.append_property(
          :condition_based_services,
          %{
            description: "hello",
            due_status: :ok,
            # identifier: 1,
            id: 1,
            month: 12,
            text: "hello",
            year: 2021
          },
          ~U[2020-09-02 11:28:42.000Z]
        )

      new_state =
        state
        |> MaintenanceState.to_bin()
        |> MaintenanceState.from_bin()

      assert state == new_state
    end
  end
end
