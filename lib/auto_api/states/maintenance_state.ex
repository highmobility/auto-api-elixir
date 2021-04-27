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
defmodule AutoApiL12.MaintenanceState do
  @moduledoc """
  Maintenance state
  """

  alias AutoApiL12.{State, UnitType}

  use AutoApiL12.State, spec_file: "maintenance.json"

  @type condition_based_services :: %{
          year: integer,
          month: integer,
          identifier: integer,
          due_status: :ok | :pending | :overdue,
          text: String.t(),
          description: String.t()
        }

  @type activity :: :inactive | :active
  @type teleservice_availability :: :pending | :idle | :successful | :error

  @type t :: %__MODULE__{
          # Deprecated
          days_to_next_service: State.property(UnitType.duration()),
          # Deprecated
          kilometers_to_next_service: State.property(UnitType.length()),
          cbs_reports_count: State.property(integer),
          # Deprecated
          months_to_exhaust_inspection: State.property(UnitType.duration()),
          teleservice_availability: State.property(teleservice_availability),
          service_distance_threshold: State.property(UnitType.length()),
          service_time_threshold: State.property(UnitType.duration()),
          automatic_teleservice_call_date: State.property(DateTime.t()),
          teleservice_battery_call_date: State.property(DateTime.t()),
          next_inspection_date: State.property(DateTime.t()),
          condition_based_services: State.multiple_property(condition_based_services),
          brake_fluid_change_date: State.property(DateTime.t()),
          time_to_next_service: State.property(UnitType.duration()),
          distance_to_next_service: State.property(UnitType.length()),
          time_to_exhaust_inspection: State.property(UnitType.duration()),
          last_ecall: State.property(DateTime.t())
        }

  @doc """
  Build state based on binary value

  ## Example

      iex> AutoApiL12.MaintenanceState.from_bin(<<3, 0, 4, 1, 0, 1, 42>>)
      %AutoApiL12.MaintenanceState{cbs_reports_count: %AutoApiL12.Property{data: 42}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

  ## Example

      iex> state = %AutoApiL12.MaintenanceState{cbs_reports_count: %AutoApiL12.Property{data: 42}}
      iex> AutoApiL12.MaintenanceState.to_bin(state)
      <<3, 0, 4, 1, 0, 1, 42>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
