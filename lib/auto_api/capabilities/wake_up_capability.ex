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
defmodule AutoApi.WakeUpCapability do
  @moduledoc """
  Basic settings for Wake Up Capability

      iex> alias AutoApi.WakeUpCapability, as: W
      iex> W.identifier
      <<0x00, 0x22>>
      iex> W.name
      :wake_up
      iex> W.description
      "Wake Up"
      iex> List.first(W.properties)
      {1, :status}
  """

  @command_module AutoApi.WakeUpCommand
  @state_module AutoApi.WakeUpState

  use AutoApi.Capability, spec_file: "wake_up.json"
end
