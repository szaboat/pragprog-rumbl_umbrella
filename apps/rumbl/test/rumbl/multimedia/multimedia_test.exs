defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category

  describe "categories" do
    test "list alphabetical categories/0" do
      for name <- ~w(Drama Action Comedy), do: Multimedia.create_category(name)

      alpha_names =
        for %Category{name: name} <- Multimedia.list_alphabetical_categories() do
          name
        end
      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    setup do
      {:ok, user: user_fixture()}
    end

    alias Rumbl.Multimedia.Video
    @valid_attrs %{description: "desc", title: "title", url: "http://local"} 
    @invalid_attrs %{description: nil, title: nil, url: nil}

    test "list_videos/0 returns all videos", %{user: owner} do
      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()
      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos() 
    end

    test "get_video!/1 returns the video with given id", %{user: owner} do
      %Video{id: id} = video_fixture(owner)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/2 with valid data creates a video", %{user: owner} do 
      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, @valid_attrs) 
      assert video.description == "desc"
      assert video.title == "title"
      assert video.url == "http://local"
    end

    test "create_video/2 with invalid data returns error changeset", %{user: owner} do
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data updates the video", %{user: owner} do
      video = video_fixture(owner)
      assert {:ok, video} = Multimedia.update_video(video, %{title: "updated title"})
      assert %Video{} = video
      assert video.title == "updated title"
    end
    
    test "update_video/2 with invalid data returns error changeset", %{user: owner} do
      %Video{id: id} = video = video_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end
    
    test "delete_video/1 deletes the video", %{user: owner} do
      video = video_fixture(owner)
      assert {:ok, %Video{}} = Multimedia.delete_video(video)
      assert Multimedia.list_videos() == []
    end

    test "change_video/2 returns a video changeset", %{user: owner} do
      video = video_fixture(owner)
      assert %Ecto.Changeset{} = Multimedia.change_video(owner, video)
    end
  end 
end