defmodule AutoApi.CustomType do
  require AutoApi.CustomType.Implementation

  @before_compile AutoApi.CustomType.Implementation
end
