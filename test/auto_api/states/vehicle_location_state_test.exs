defmodule AutoApi.VehicleLocationStateTest do
  use ExUnit.Case, async: true
  doctest AutoApi.VehicleLocationState
  alias AutoApi.VehicleLocationState

  test "to_bin/1 & from_bin" do
    state =
      %VehicleLocationState{}
      |> VehicleLocationState.put_property(:altitude, {133.5, :meters})
      |> VehicleLocationState.put_property(:heading, {0.5, :degrees})
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
