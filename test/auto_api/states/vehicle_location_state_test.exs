defmodule AutoApiL11.VehicleLocationStateTest do
  use ExUnit.Case
  doctest AutoApiL11.VehicleLocationState
  alias AutoApiL11.VehicleLocationState

  test "to_bin/1 & from_bin" do
    state =
      %VehicleLocationState{}
      |> VehicleLocationState.put_property(:altitude, 133.5)
      |> VehicleLocationState.put_property(:heading, 0.5)
      |> VehicleLocationState.put_property(:coordinates, %{
        latitude: 52.516506,
        longitude: 13.381815
      })

    new_state =
      state
      |> VehicleLocationState.to_bin()
      |> VehicleLocationState.from_bin()

    assert new_state == state
  end
end
