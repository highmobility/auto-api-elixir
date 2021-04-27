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
defmodule AutoApiL12.VehicleTimeCapability do
  @moduledoc """
  Basic settings for Vehicle Time Capability

      iex> alias AutoApiL12.VehicleTimeCapability, as: VT
      iex> VT.identifier
      <<0x00, 0x50>>
      iex> VT.name
      :vehicle_time
      iex> VT.description
      "Vehicle Time"
      iex> length(VT.properties)
      6
      iex> List.first(VT.properties)
      {1, :vehicle_time}
  """

  @command_module AutoApiL12.LegacyCommand
  @state_module AutoApiL12.VehicleTimeState

  use AutoApiL12.Capability, spec_file: "vehicle_time.json"
end
