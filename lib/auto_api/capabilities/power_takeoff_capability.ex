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
defmodule AutoApiL12.PowerTakeoffCapability do
  @moduledoc """
  Basic settings for Power Takeoff Capability

      iex> alias AutoApiL12.PowerTakeoffCapability, as: PT
      iex> PT.identifier
      <<0x0, 0x65>>
      iex> PT.name
      :power_takeoff
      iex> PT.description
      "Power Take-Off"
      iex> length(PT.properties)
      7
      iex> List.first(PT.properties)
      {1, :status}
  """

  @command_module AutoApiL12.LegacyCommand
  @state_module AutoApiL12.PowerTakeoffState

  use AutoApiL12.Capability, spec_file: "power_takeoff.json"
end
