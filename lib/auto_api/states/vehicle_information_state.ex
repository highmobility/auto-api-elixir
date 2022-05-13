# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.VehicleInformationState do
  @moduledoc """
  VehicleInformation state
  """

  alias AutoApi.{State, UnitType}

  use AutoApi.State, spec_file: "vehicle_information.json"

  @type powertrain ::
          :unknown
          | :all_electric
          | :combustion_engine
          | :phev
          | :hydrogen
          | :hydrogen_hybrid
          | :petrol
          | :electric
          | :gas
          | :diesel
          | :gasoline
          | :cng
          | :lpg
          | :hybrid

  @type gearbox :: :manual | :automatic | :semi_automatic

  @type drive :: :fwd | :rwd | :four_wd | :awd

  @type data_quality :: :no_data | :up_to_date | :almost_up_to_date | :out_of_date

  @type time_zone :: :wintertime | :summertime | :utc | :manual

  @type t :: %__MODULE__{
          powertrain: State.property(powertrain()),
          model_name: State.property(String.t()),
          name: State.property(String.t()),
          license_plate: State.property(String.t()),
          sales_designation: State.property(String.t()),
          model_year: State.property(integer()),
          colour_name: State.property(String.t()),
          # Deprecated!
          power_in_kw: State.property(UnitType.power()),
          number_of_doors: State.property(integer()),
          number_of_seats: State.property(integer()),
          engine_volume: State.property(UnitType.volume()),
          engine_max_torque: State.property(UnitType.torque()),
          gearbox: State.property(gearbox()),
          display_unit: State.property(:km | :miles),
          driver_seat_location: State.property(:left | :right | :center),
          equipments: State.multiple_property(String.t()),
          power: State.property(UnitType.power()),
          language: State.property(String.t()),
          timeformat: State.property(:twelve_h | :twenty_four_h),
          drive: State.property(drive()),
          powertrain_secondary: State.property(powertrain()),
          fuel_tank_capacity: State.property(UnitType.volume()),
          build_date: State.property(DateTime.t()),
          country_code: State.property(String.t()),
          model_key: State.property(String.t()),
          data_quality: State.property(data_quality),
          extra_equipment_codes: State.multiple_property(String.t()),
          series: State.property(String.t()),
          last_data_transfer_date: State.property(DateTime.t()),
          time_zone: State.property(time_zone)
        }

  @doc """
  Build state based on binary value

    iex> bin = <<4, 0, 13, 1, 0, 10, 72, 77, 32, 67, 111, 110, 99, 101, 112, 116>>
    iex> AutoApi.VehicleInformationState.from_bin(bin)
    %AutoApi.VehicleInformationState{name: %AutoApi.Property{data: "HM Concept"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.VehicleInformationState{name: %AutoApi.Property{data: "HM Concept"}}
    iex> AutoApi.VehicleInformationState.to_bin(state)
    <<4, 0, 13, 1, 0, 10, 72, 77, 32, 67, 111, 110, 99, 101, 112, 116>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
