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
defmodule AutoApi.CruiseControlState do
  @moduledoc """
  CruiseControl state
  """

  alias AutoApi.CommonData

  defstruct cruise_control: nil,
            limiter: nil,
            target_speed: nil,
            acc: nil,
            acc_target_speed: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/cruise_control.json"

  @type cruise_control :: :inactive | :active | nil
  @type limiter ::
          :not_set | :higher_speed_requested | :lower_speed_requested | :speed_fixed | nil
  @type acc :: :inactive | :active | nil

  @type t :: %__MODULE__{
          cruise_control: cruise_control | nil,
          limiter: limiter | nil,
          target_speed: integer | nil,
          acc: acc | nil,
          acc_target_speed: integer | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
