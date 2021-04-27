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
defmodule AutoApiL12.CapabilitiesState do
  @moduledoc """
  Capabilities state

  This is a minimal implementation that has low-level capability and
  property binary IDs in the struct as well. A future implementation
  will translate those into modules and property names.
  """

  alias AutoApiL12.State

  use AutoApiL12.State, spec_file: "capabilities.json"

  @type capability :: %{
          capability_id: integer(),
          supported_property_ids: binary()
        }

  @type event ::
          :ping
          | :trip_started
          | :trip_ended
          | :vehicle_location_changed
          | :authorization_changed
          | :tire_pressure_changed

  @type webhook :: %{
          available: :available | :unavailable,
          event: event()
        }

  @type t :: %__MODULE__{
          capabilities: State.multiple_property(capability()),
          webhooks: State.multiple_property(webhook())
        }

  @doc """
  Build state based on binary value

  ## Examples

      iex> bin = <<1, 0, 9, 1, 0, 6, 0, 51, 0, 2, 4, 13>>
      iex> AutoApiL12.CapabilitiesState.from_bin(bin)
      %AutoApiL12.CapabilitiesState{capabilities: [%AutoApiL12.Property{data: %{capability_id: 0x33, supported_property_ids: <<0x04, 0x0D>>}}]}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(binary) do
    parse_bin_properties(binary, %__MODULE__{})
  end

  @doc """
  Parse state to bin

  ## Examples

      iex> state = %AutoApiL12.CapabilitiesState{capabilities: [%AutoApiL12.Property{data: %{capability_id: 0x33, supported_property_ids: <<0x04, 0x0D>>}}]}
      iex> AutoApiL12.CapabilitiesState.to_bin(state)
      <<1, 0, 9, 1, 0, 6, 0, 51, 0, 2, 4, 13>>

  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
