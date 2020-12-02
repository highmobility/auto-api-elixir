defmodule AutoApiL11.VehicleStatusStateTest do
  use ExUnit.Case
  doctest AutoApiL11.VehicleStatusState
  alias AutoApiL11.VehicleStatusState

  test "to_bin/1 & from_bin/1" do
    state =
      %VehicleStatusState{}
      |> VehicleStatusState.put_property(:vin, "JYE8GP0078A086432")
      |> VehicleStatusState.put_property(:powertrain, :all_electric)
      |> VehicleStatusState.put_property(:gearbox, :semi_automatic)
      |> VehicleStatusState.put_property(:model_name, "HM Concept")
      |> VehicleStatusState.append_property(:equipments, "eq 1")
      |> VehicleStatusState.append_property(:equipments, "eq 2")

    new_state =
      state
      |> VehicleStatusState.to_bin()
      |> VehicleStatusState.from_bin()

    assert state == new_state
  end

  test "Correctly encodes state in to_bin/1" do
    diag_state =
      AutoApiL11.DiagnosticsState.base()
      |> AutoApiL11.DiagnosticsState.put_property(:speed, 42, ~U[2020-12-02 12:31:17.436Z])

    door_state =
      AutoApiL11.DoorsState.base()
      |> AutoApiL11.DoorsState.append_property(:positions, %{
        location: :front_left,
        position: :closed
      })

    diag_state_bin = AutoApiL11.DiagnosticsCommand.state(diag_state)
    diag_state_bin_size = byte_size(diag_state_bin)

    door_state_bin = AutoApiL11.DoorsCommand.state(door_state)
    door_state_bin_size = byte_size(door_state_bin)

    state =
      VehicleStatusState.base()
      |> VehicleStatusState.append_property(:states, diag_state)
      |> VehicleStatusState.append_property(:states, door_state)

    bin_state = VehicleStatusState.to_bin(state)

    assert bin_state ==
             <<0x99, diag_state_bin_size + 3::integer-16, 0x01, diag_state_bin_size::integer-16,
               diag_state_bin::binary, 0x99, door_state_bin_size + 3::integer-16, 0x01,
               door_state_bin_size::integer-16, door_state_bin::binary>>

    assert state == VehicleStatusState.from_bin(bin_state)
  end

  test "Correctly decodes state from_bin/1" do
    bin_state =
      <<153, 0, 26, 1, 0, 23, 11, 0, 51, 1, 3, 0, 16, 1, 0, 2, 0, 42, 2, 0, 8, 0, 0, 1, 118, 35,
        111, 123, 188, 153, 0, 15, 1, 0, 12, 11, 0, 32, 1, 4, 0, 5, 1, 0, 2, 0, 0>>

    state = VehicleStatusState.from_bin(bin_state)

    assert [diag_state, door_state] = state.states

    assert diag_state.data.speed.data == 42
    assert diag_state.data.speed.timestamp == ~U[2020-12-02 12:31:17.436Z]
    refute diag_state.data.speed.failure

    assert [position] = door_state.data.positions
    assert position.data.location == :front_left
    assert position.data.position == :closed
    refute position.timestamp
    refute position.failure
  end
end
