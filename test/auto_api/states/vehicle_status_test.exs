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
defmodule AutoApi.VehicleStatusStateTest do
  use ExUnit.Case
  alias AutoApi.VehicleStatusState

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
      AutoApi.DiagnosticsState.base()
      |> AutoApi.DiagnosticsState.put_property(:speed, 42, DateTime.utc_now())
    door_state =
      AutoApi.DoorLocksState.base()
      |> AutoApi.DoorLocksState.append_property(:positions, %{
        door_location: :front_left,
        position: :closed
      })
    diag_state_bin = AutoApi.DiagnosticsState.identifier() <> <<0x01>> <> AutoApi.DiagnosticsState.to_bin(diag_state)
    diag_state_bin_size = byte_size(diag_state_bin)
    door_state_bin = AutoApi.DoorLocksState.identifier() <> <<0x01>> <> AutoApi.DoorLocksState.to_bin(door_state)
    door_state_bin_size = byte_size(door_state_bin)

    state =
      VehicleStatusState.base()
      |> VehicleStatusState.append_property(:state, diag_state)
      |> VehicleStatusState.append_property(:state, door_state)
      |> VehicleStatusState.to_bin()

    assert state == <<0x99, (diag_state_bin_size + 3)::integer-16, 0x01, diag_state_bin_size::integer-16, diag_state_bin::binary,
      0x99, (door_state_bin_size + 3)::integer-16, 0x01, door_state_bin_size::integer-16, door_state_bin::binary>>
  end
end
