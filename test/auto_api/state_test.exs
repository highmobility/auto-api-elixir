# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.StateTest do
  use ExUnit.Case

  alias AutoApi.{
    CapabilitiesState,
    DiagnosticsState,
    PropertyComponent,
    RooftopControlState,
    State,
    VehicleLocationState,
    VehicleStatusState
  }

  describe "symmetric from_bin/1 & to_bin/1" do
    test "integer size 4" do
      state = %DiagnosticsState{mileage: %PropertyComponent{data: 16_777_215}}

      new_state =
        state
        |> DiagnosticsState.to_bin()
        |> DiagnosticsState.from_bin()

      assert new_state.mileage.data == 16_777_215
    end

    test "integer size 2" do
      state = %DiagnosticsState{speed: %PropertyComponent{data: 65_535}}

      new_state =
        state
        |> DiagnosticsState.to_bin()
        |> DiagnosticsState.from_bin()

      assert new_state.speed.data == 65_535
    end

    test "double size 8" do
      state = %DiagnosticsState{fuel_level: %PropertyComponent{data: 1.1002}}

      new_state =
        state
        |> DiagnosticsState.to_bin()
        |> DiagnosticsState.from_bin()

      assert new_state.fuel_level.data == 1.1002
    end

    test "float size 4" do
      state = %DiagnosticsState{engine_total_fuel_consumption: %PropertyComponent{data: 1.1003}}

      new_state =
        state
        |> DiagnosticsState.to_bin()
        |> DiagnosticsState.from_bin()

      assert new_state.engine_total_fuel_consumption.data == 1.1003
    end

    test "string" do
      state = %VehicleStatusState{vin: %PropertyComponent{data: "XV000000000000001"}}

      new_state =
        state
        |> VehicleStatusState.to_bin()
        |> VehicleStatusState.from_bin()

      assert new_state.vin.data == "XV000000000000001"
    end

    test "bytes" do
      state = %CapabilitiesState{
        capabilities: [
          %PropertyComponent{data: %{capability_id: 0x33, supported_property_ids: <<0x04, 0x0D>>}}
        ]
      }

      new_state =
        state
        |> CapabilitiesState.to_bin()
        |> CapabilitiesState.from_bin()

      assert data = List.first(new_state.capabilities).data
      assert data.supported_property_ids == <<0x04, 0x0D>>
    end

    test "enum" do
      state = %DiagnosticsState{brake_fluid_level: %PropertyComponent{data: :low}}

      new_state =
        state
        |> DiagnosticsState.to_bin()
        |> DiagnosticsState.from_bin()

      assert new_state.brake_fluid_level.data == :low
    end

    test "capability_state" do
      inner_state = %DiagnosticsState{brake_fluid_level: %PropertyComponent{data: :low}}
      state = %VehicleStatusState{states: [%PropertyComponent{data: inner_state}]}

      new_state =
        state
        |> VehicleStatusState.to_bin()
        |> VehicleStatusState.from_bin()

      assert new_state.states == [%PropertyComponent{data: inner_state}]
    end

    test "map" do
      coordinates = %PropertyComponent{data: %{latitude: 52.442292, longitude: 13.176732}}
      state = %VehicleLocationState{coordinates: coordinates}

      new_state =
        state
        |> VehicleLocationState.to_bin()
        |> VehicleLocationState.from_bin()

      assert new_state.coordinates == coordinates
    end

    test "list of map" do
      tire_pressures = %PropertyComponent{data: %{location: :front_left, pressure: 22.034}}

      state =
        %DiagnosticsState{tire_pressures: [tire_pressures]}
        |> DiagnosticsState.to_bin()
        |> DiagnosticsState.from_bin()

      assert state.tire_pressures == [tire_pressures]
    end

    test "failure" do
      coordinates = %PropertyComponent{failure: %{reason: :unknown, description: "Unknown"}}
      state = %VehicleLocationState{coordinates: coordinates}

      new_state =
        state
        |> VehicleLocationState.to_bin()
        |> VehicleLocationState.from_bin()

      assert new_state.coordinates == coordinates
    end

    test "converts enum with nil value to bin and back to struct" do
      state = %RooftopControlState{
        sunroof_state: %PropertyComponent{failure: %{reason: :unknown, description: ""}},
        sunroof_tilt_state: %PropertyComponent{failure: %{reason: :unknown, description: ""}}
      }

      new_state =
        state
        |> RooftopControlState.to_bin()
        |> RooftopControlState.from_bin()

      assert state == new_state
    end

    test "failure on list property" do
      pressures = %PropertyComponent{failure: %{reason: :unknown, description: "Unknown"}}
      state = %DiagnosticsState{tire_pressures: [pressures]}

      new_state =
        state
        |> DiagnosticsState.to_bin()
        |> DiagnosticsState.from_bin()

      assert new_state.tire_pressures == [pressures]
    end
  end

  describe "put_failure/5" do
    test "only failure" do
      state = %DiagnosticsState{mileage: %PropertyComponent{data: 16_777_215}}
      new_state = State.put_failure(state, :speed, :unknown, "Unknown speed")

      assert new_state.mileage.data == 16_777_215
      assert new_state.speed.failure.reason == :unknown
      assert new_state.speed.failure.description == "Unknown speed"
      assert new_state.speed.timestamp == nil
    end

    test "failure with timestamp" do
      timestamp = DateTime.utc_now()
      state = %DiagnosticsState{mileage: %PropertyComponent{data: 16_777_215}}

      new_state = State.put_failure(state, :speed, :unknown, "Unknown speed", timestamp)

      assert new_state.mileage.data == 16_777_215
      assert new_state.speed.failure.reason == :unknown
      assert new_state.speed.failure.description == "Unknown speed"
      assert new_state.speed.timestamp == timestamp
    end

    test "failure on maps property overrides data" do
      timestamp = DateTime.utc_now()

      state =
        DiagnosticsState.base()
        |> DiagnosticsState.append_property(:tire_pressures, %{
          location: :front_left,
          pressure: 22.034
        })
        |> State.put_failure(:tire_pressures, :unknown, "Unknown pressure", timestamp)

      assert [pressures] = state.tire_pressures
      refute pressures.data
      assert pressures.failure.reason == :unknown
      assert pressures.failure.description == "Unknown pressure"
      assert pressures.timestamp == timestamp
    end
  end

  describe "update_property/4" do
    test "update a property with single value" do
      now = DateTime.utc_now()
      state = %DiagnosticsState{}
      new_state = AutoApi.State.update_property(state, :mileage, 1000, now)

      assert new_state.mileage.data == 1000
      assert new_state.mileage.timestamp == now
    end

    test "update a property with multiple valus " do
      now = DateTime.utc_now()
      state = %DiagnosticsState{}
      assert state.tire_pressures == []

      new_state =
        AutoApi.State.update_property(
          state,
          :tire_pressures,
          %{location: :front_right, pressure: 1.938},
          now
        )

      assert tire_info = List.first(new_state.tire_pressures)
      assert tire_info.timestamp == now
    end
  end
end
