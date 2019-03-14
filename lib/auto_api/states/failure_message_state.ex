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
defmodule AutoApi.FailureMessageState do
  @moduledoc """
  Keeps Failure Message state
  """

  alias AutoApi.PropertyComponent

  @type failure_reason ::
          :unsupported_capability
          | :unauthorised
          | :unauthorized
          | :incorrect_state
          | :execution_timeout
          | :vehicle_asleep
          | :invalid_command

  @doc """
  FailureMessage state
  """
  defstruct failed_message_identifier: nil,
            failed_message_type: nil,
            failure_reason: nil,
            failure_description: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/failure_message.json"

  @type t :: %__MODULE__{
          failed_message_identifier: %PropertyComponent{data: integer} | nil,
          failed_message_type: %PropertyComponent{data: integer} | nil,
          failure_reason: %PropertyComponent{data: failure_reason} | nil,
          failure_description: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<4, 0, 21, 1, 0, 18, 115, 111, 109, 101, 116, 104, 105, 110, 103, 32, 104, 97, 112, 112, 101, 110, 101, 100>>
    iex> AutoApi.FailureMessageState.from_bin(bin)
    %AutoApi.FailureMessageState{failure_description: %AutoApi.PropertyComponent{data: "something happened"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    bin
    |> parse_bin_properties(%__MODULE__{})
    |> unify_unauthorized_from_bin
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.FailureMessageState{failure_description: %AutoApi.PropertyComponent{data: "something happened"}}
    iex> AutoApi.FailureMessageState.to_bin(state)
    <<4, 0, 21, 1, 0, 18, 115, 111, 109, 101, 116, 104, 105, 110, 103, 32, 104, 97, 112, 112, 101, 110, 101, 100>>
  """
  def to_bin(%__MODULE__{} = state) do
    state
    |> unify_unauthorized_to_bin
    |> parse_state_properties()
  end

  defp unify_unauthorized_from_bin(
         %{failure_reason: %{data: :unauthorised} = failure_reason} = state
       ) do
    %{state | failure_reason: %{failure_reason | data: :unauthorized}}
  end

  defp unify_unauthorized_from_bin(value), do: value

  defp unify_unauthorized_to_bin(
         %{failure_reason: %{data: :unauthorized} = failure_reason} = state
       ) do
    %{state | failure_reason: %{failure_reason | data: :unauthorised}}
  end

  defp unify_unauthorized_to_bin(value), do: value
end
