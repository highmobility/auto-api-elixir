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
defmodule AutoApi.FailureMessageState do
  @moduledoc """
  Keeps Failure Message state
  """

  alias AutoApi.Command

  use AutoApi.State, spec_file: "failure_message.json"

  @doc """
  Creates a failure state based on a command

  # Example

      iex> command = AutoApi.GetCommand.new(AutoApi.RaceCapability, [])
      iex> #{__MODULE__}.from_command(command, :oem_error, "Vehicle is not available")
      %#{__MODULE__}{
        failed_message_id: %AutoApi.Property{data: 87},
        failed_message_type: %AutoApi.Property{data: 0},
        failure_reason: %AutoApi.Property{data: :oem_error},
        failure_description: %AutoApi.Property{data: "Vehicle is not available"}
      }
  """
  @spec from_command(Command.t(), failure_reason(), String.t()) :: t()
  def from_command(command, reason, description) do
    <<identifier::integer-16>> = command.capability.identifier()
    command_id = Command.identifier(command)

    base()
    |> put(:failed_message_id, data: identifier)
    |> put(:failed_message_type, data: command_id)
    |> put(:failure_reason, data: reason)
    |> put(:failure_description, data: description)
  end

  @doc """
  Build state based on binary value

    iex> bin = <<4, 0, 21, 1, 0, 18, 115, 111, 109, 101, 116, 104, 105, 110, 103, 32, 104, 97, 112, 112, 101, 110, 101, 100>>
    iex> AutoApi.FailureMessageState.from_bin(bin)
    %AutoApi.FailureMessageState{failure_description: %AutoApi.Property{data: "something happened"}}
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

    iex> state = %AutoApi.FailureMessageState{failure_description: %AutoApi.Property{data: "something happened"}}
    iex> AutoApi.FailureMessageState.to_bin(state)
    <<4, 0, 21, 1, 0, 18, 115, 111, 109, 101, 116, 104, 105, 110, 103, 32, 104, 97, 112, 112, 101, 110, 101, 100>>
  """
  def to_bin(%__MODULE__{} = state) do
    state
    |> unify_unauthorized_to_bin
    |> parse_state_properties()
  end

  #  defp unify_unauthorized_from_bin(
  #         %{failure_reason: %{data: :unauthorised} = failure_reason} = state
  #       ) do
  #    %{state | failure_reason: %{failure_reason | data: :unauthorized}}
  #  end

  defp unify_unauthorized_from_bin(value), do: value

  defp unify_unauthorized_to_bin(
         %{failure_reason: %{data: :unauthorized} = failure_reason} = state
       ) do
    %{state | failure_reason: %{failure_reason | data: :unauthorised}}
  end

  defp unify_unauthorized_to_bin(value), do: value

  @failure_reason_map %{
    0x00 => :rate_limit,
    0x01 => :execution_timeout,
    0x02 => :format_error,
    0x03 => :unauthorised,
    0x04 => :unknown,
    0x05 => :pending,
    0x06 => :oem_error,
    0x07 => :privacy_mode_active
  }

  def failure_reason_bin_to_name(id), do: Map.fetch!(@failure_reason_map, id)

  def failure_reason_name_to_bin(name) do
    @failure_reason_map |> Enum.into(%{}, fn {k, v} -> {v, k} end) |> Map.fetch!(name)
  end
end
