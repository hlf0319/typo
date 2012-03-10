require 'spec_helper'

describe "admin/content/new.html.erb" do
  before do
    admin = stub_model(User, :settings => {:editor => 'simple'}, :admin? => true,
                       :text_filter_name => "", :profile_label => "admin")
    blog = mock_model(Blog, :base_url => "http://myblog.net/")
    article = stub_model(Article).as_new_record
    text_filter = stub_model(TextFilter)

    article.stub(:text_filter) { text_filter }
    view.stub(:current_user) { admin }
    view.stub(:this_blog) { blog }

    # FIXME: Nasty. Controller should pass in @categories and @textfilters.
    Category.stub(:all) { [] }
    TextFilter.stub(:all) { [text_filter] }

    assign :article, article
  end

  it "renders with no resources or macros" do
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
    render
  end

  it "renders with image resources" do
    # FIXME: Nasty. Thumbnail creation should not be controlled by the view.
    img = mock_model(Resource, :filename => "foo", :create_thumbnail => nil)
    assign(:images, [img])
    assign(:macros, [])
    assign(:resources, [])
    render
  end

  describe "when editing an article" do
    before :each do
      article = stub_model(Article, :id => 1)
      assign :article, article
      assign(:images, [])
      assign(:macros, [])
      assign(:resources, [])
      view.stub(:link_to_destroy_with_profiles)
      article.stub(:text_filter).and_return(stub_model(TextFilter))
    end

    it "renders the merge article functionality for an admin" do
      render
      rendered.should contain 'Merge Articles'
    end

    it "does not render the merge article functionality for a non-admin" do
      non_admin = stub_model(User, :settings => {:editor => 'simple'}, :admin? => false, :text_filter_name => "", :profile_label => "publisher")
      view.stub(:current_user) { non_admin }
      render
      rendered.should_not contain 'Merge Articles'
    end

  end

end
