defmodule Plug.Session.CREAM do
  @moduledoc false

  @behaviour Plug.Session.Store

  alias Plug.Session.CREAM.Cache

  def init(options), do: options

  def get(_conn, cookie, _options) do
    session = cache().get(namespace(cookie)) || %{}
    {cookie, session}
  end

  def put(conn, nil, value, options) do
    sid = :crypto.strong_rand_bytes(32)
      |> Base.encode16
      |> String.downcase
    put(conn, sid, value, options)
  end

  def put(_conn, sid, value, _options) do
    cache().set({namespace(sid), value})
    sid
  end

  def delete(_conn, sid, _options) do
    cache().delete(namespace(sid))
    :ok
  end

  defp cache do
    Application.get_env(:plug_session_cream, :cache, Cache)
  end

  defp namespace(key) do
    case Application.get_env(:plug_session_cream, :namespace) do
      nil -> key
      namespace -> "#{namespace}:#{key}"
    end
  end

end
