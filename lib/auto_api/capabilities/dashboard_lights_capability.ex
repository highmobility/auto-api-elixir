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
defmodule AutoApiL12.DashboardLightsCapability do
  @moduledoc """
  Basic settings for Browser Capability

      iex> alias AutoApiL12.DashboardLightsCapability, as: F
      iex> F.identifier
      <<0x00, 0x61>>
      iex> F.name
      :dashboard_lights
      iex> F.description
      "Dashboard Lights"
      iex> length(F.properties)
      6
      iex> List.first(F.properties)
      {0x01, :dashboard_lights}
  """

  @command_module AutoApiL12.LegacyCommand
  @state_module AutoApiL12.DashboardLightsState

  use AutoApiL12.Capability, spec_file: "dashboard_lights.json"
end
