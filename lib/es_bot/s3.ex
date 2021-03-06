defmodule ESBot.S3 do
  require Logger

  @bucket Application.fetch_env!(:es_bot, :s3_bucket)
  @spec store_emote(String.t()) :: {:ok, String.t()} | {:error, any()}
  def store_emote(url) do
    with {:ok, %{status_code: 200, body: body}} <- HTTPoison.get(url),
         {mimetype, ext} <- ExImageInfo.type(body),
         dest_path <- gen_id() <> "." <> simplify_ext(ext),
         request <- ExAws.S3.put_object(@bucket, dest_path, body, content_type: mimetype, acl: :public_read),
         {:ok, %{status_code: 200}} <- ExAws.request(request) do
      {:ok, dest_path}
    else
      err ->
        Logger.error("ERROR: #{inspect(err)}")
        err
    end
  end

  @spec get_emote(String.t()) :: {:ok, binary} | any()
  def get_emote(id) do
    with {:ok, %{body: body}} <- ExAws.S3.get_object(@bucket, id) |> ExAws.request() do
      {:ok, body}
    else
      err ->
        Logger.error("ERROR: #{inspect(err)}")
        err
    end
  end

  @spec get_emote_url(String.t()) :: String.t()
  def get_emote_url(emote_id), do: "https://#{@bucket}.s3.us-east-2.amazonaws.com/#{emote_id}"

  @id_len 9
  @spec gen_id :: String.t()
  def gen_id() do
    characters =
      Enum.concat([?a..?z, ?A..?Z, ?0..?9])
      |> Enum.map(&<<&1>>)

    Stream.repeatedly(fn -> Enum.random(characters) end)
    |> Enum.take(@id_len)
    |> Enum.join()
  end

  defp simplify_ext(ext), do: simplify_ext(String.downcase(ext), true)
  defp simplify_ext("gif89a", true), do: "gif"
  defp simplify_ext(ext, true), do: ext
end
