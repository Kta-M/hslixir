defmodule Scripts do
  use Slack

  require HTTPoison
  require Floki

  def hear("パイセン？", message, slack) do
    msgs = ["マジっすか。", "ヤバいっす。", "うむ。"]
    len  = length(msgs)

    Enum.at(msgs, :random.uniform(len) - 1)
    |> send_message(message.channel, slack)
  end

  def hear("応援して", message, slack) do
    msgs = [
      "「できる、できない」を決めるのは自分だ ",
      "今日から君は噴水だ！",
      "苦しい時ほど、笑ってごらん ",
      "トンネルから抜け出せ！ 動いて、動きまくれ！ ",
      "昇ってこいよ！ 君は太陽だから！ ",
      "次に叩く一回で、 その壁は破れるかもしれない ",
      "カメはベストを尽くした。 君はどうだ？ ",
      "打ち上げてごらん、心の花火を ",
      "大丈夫、君は一人じゃない ",
    ]
    len  = length(msgs)

    HTTPoison.start
    url = URI.encode("http://ajax.googleapis.com/ajax/services/search/images")
    query = URI.encode_query(%{
      v:       "1.0",
      rez:     "small",
      safe:    "active",
      q:       "松岡修造",
      imgtype: "face",
      start:   :random.uniform(60)
    })
    case HTTPoison.get(url <> "?" <> query) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
        data_json = Poison.Parser.parse!(body)
        Enum.at(data_json["responseData"]["results"], 0)["url"]
        |> send_message(message.channel, slack)
        Enum.at(msgs, :random.uniform(len) - 1)
        |> send_message(message.channel, slack)
      {_, _} -> nil
    end
  end

  def hear("lgtm", message, slack) do
    HTTPoison.start
    case URI.encode("http://www.lgtm.in/g") |> HTTPoison.get do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
        |> Floki.find("#imageUrl")
        |> Floki.attribute("value")
        |> hd
        |> send_message(message.channel, slack)
      {_, _} -> nil
    end
  end

  # Don't remove. This is default pattern.
  def hear(_, _, _) do
  end

  def respond("respond?", message, slack) do
    send_message("I can respond", message.channel, slack)
  end

  # Don't remove. This is default pattern.
  def respond(_, _, _) do
  end

end
