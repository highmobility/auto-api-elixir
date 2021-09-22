# AutoAPI
# The MIT License
#
# Copyright (c) 2021- High-Mobility GmbH (https://high-mobility.com)
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
defmodule AutoApi.UniversalCapability do
  @moduledoc """
  Basic settings for Universal Capability

      iex> alias AutoApi.UniversalCapability, as: U
      iex> U.identifier
      <<0x00, 0x15>>
      iex> U.name
      :universal
      iex> U.description
      "Universal"
      iex> length(U.properties)
      5
      iex> U.properties
      [{160, :nonce}, {161, :vehicle_signature}, {162, :timestamp}, {163, :vin}, {164, :brand}]
  """

  @command_module AutoApi.LegacyCommand
  @state_module AutoApi.UniversalState

  use AutoApi.Capability, spec_file: "universal.json"
end
