module ApplicationHelper
  def default_meta_tags
    {
      site: "gamers-room",
      title: "トップページ",
      description: "リアルタイムでゲーム募集",
      keywords: "ゲーム募集, パーティー募集, ゲーム",
      canonical: request.original_url,
      separator: "|",
      icon: {
        href: image_url("1.png")
      },
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: :url,
        image: image_url("1.png"),
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("1.png")
      }
    }
  end
end
