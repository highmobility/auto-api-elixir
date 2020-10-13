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
defmodule AutoApi.MaintenanceState do
  @moduledoc """
  Maintenance state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  use AutoApi.State, spec_file: "maintenance.json"

  @type condition_based_services :: %PropertyComponent{
          data: %{
            year: integer,
            month: integer,
            identifier: integer,
            due_status: :ok | :pending | :overdue,
            text_size: integer,
            text: String.t(),
            description_size: integer,
            description: String.t()
          }
        }

  @type activity :: :inactive | :active
  @type teleservice_availability :: :pending | :idle | :successful | :error

  @type t :: %__MODULE__{
          days_to_next_service: %PropertyComponent{data: integer} | nil,
          kilometers_to_next_service: %PropertyComponent{data: integer} | nil,
          cbs_reports_count: %PropertyComponent{data: integer} | nil,
          months_to_exhaust_inspection: %PropertyComponent{data: integer} | nil,
          teleservice_availability: %PropertyComponent{data: teleservice_availability} | nil,
          service_distance_threshold: %PropertyComponent{data: integer} | nil,
          service_time_threshold: %PropertyComponent{data: integer} | nil,
          automatic_teleservice_call_date: %PropertyComponent{data: integer} | nil,
          teleservice_battery_call_date: %PropertyComponent{data: integer} | nil,
          next_inspection_date: %PropertyComponent{data: integer} | nil,
          condition_based_services: list(condition_based_services),
          brake_fluid_change_date: %PropertyComponent{data: integer} | nil
        }

  @doc """
  Build state based on binary value

  ## Example

      iex> AutoApi.MaintenanceState.from_bin(<<0x02, 7::integer-16, 0x01, 4::integer-16, -42::integer-32>>)
      %AutoApi.MaintenanceState{kilometers_to_next_service: %AutoApi.PropertyComponent{data: -42}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

  ## Example

      iex> state = %AutoApi.MaintenanceState{kilometers_to_next_service: %AutoApi.PropertyComponent{data: -42}}
      iex> AutoApi.MaintenanceState.to_bin(state)
      <<0x02, 7::integer-16, 0x01, 4::integer-16, -42::integer-32>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
