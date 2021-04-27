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
defmodule AutoApiL12.HonkHornFlashLightsCapability do
  @moduledoc """
  Basic settings for HonkHornFlashLights Capability

      iex> alias AutoApiL12.HonkHornFlashLightsCapability, as: H
      iex> H.identifier
      <<0x00, 0x26>>
      iex> H.name
      :honk_horn_flash_lights
      iex> H.description
      "Honk Horn & Flash Lights"
      iex> length(H.properties)
      10
      iex> List.first(H.properties)
      {0x01, :flashers}
  """

  @command_module AutoApiL12.LegacyCommand
  @state_module AutoApiL12.HonkHornFlashLightsState

  use AutoApiL12.Capability, spec_file: "honk_horn_flash_lights.json"
end
