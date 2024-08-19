RSpec.describe "Discourse custom logo link", system: true do
  let(:theme) { Fabricate(:theme) }
  let!(:component) { upload_theme_component(parent_theme_id: theme.id) }

  before { theme.set_default! }

  context "with anonymous user" do
    context "when on desktop" do
      context "when the desktop_url is set" do
        before do
          component.update_setting(:desktop_url, "http://www.example.com")
          component.save!
        end

        it "uses the desktop_url" do
          visit("/")

          expect(page.find(".home-logo-wrapper-outlet")).to have_link(
            href: "http://www.example.com",
          )
        end
      end

      context "when the desktop_url is not set" do
        it "defaults to root" do
          visit("/")

          expect(page.find(".home-logo-wrapper-outlet")).to have_link(href: "/")
        end
      end
    end

    context "when on mobile", mobile: true do
      context "when the mobile_url is set" do
        before do
          component.update_setting(:mobile_url, "http://www.example.com")
          component.save!
        end

        it "uses the mobile_url" do
          visit("/")

          expect(page.find(".home-logo-wrapper-outlet")).to have_link(
            href: "http://www.example.com",
          )
        end
      end

      context "when the mobile_url is not set" do
        it "defaults to root" do
          visit("/")

          expect(page.find(".home-logo-wrapper-outlet")).to have_link(href: "/")
        end
      end
    end
  end

  context "with logged in user" do
    fab!(:user)

    before { sign_in(user) }

    context "when on desktop" do
      context "when the logged_in_desktop_url is set" do
        before do
          component.update_setting(:logged_in_desktop_url, "http://www.example.com")
          component.save!
        end

        it "uses the logged_in_desktop_url" do
          visit("/")

          expect(page.find(".home-logo-wrapper-outlet")).to have_link(
            href: "http://www.example.com",
          )
        end

        context "when using tokens" do
          before do
            component.update_setting(
              :logged_in_desktop_url,
              "http://www.example.com/$username/$user_id",
            )
            component.save!
          end

          it "interpolates tokens" do
            visit("/")

            expect(page.find(".home-logo-wrapper-outlet")).to have_link(
              href: "http://www.example.com/#{user.username}/#{user.id}",
            )
          end
        end
      end

      context "when the logged_in_desktop_url is not set" do
        it "defaults to root" do
          visit("/")

          expect(page.find(".home-logo-wrapper-outlet")).to have_link(href: "/")
        end
      end
    end

    context "when on mobile", mobile: true do
      context "when the logged_in_mobile_url is set" do
        before do
          component.update_setting(:logged_in_mobile_url, "http://www.example.com")
          component.save!
        end

        it "uses the logged_in_mobile_url" do
          visit("/")

          expect(page.find(".home-logo-wrapper-outlet")).to have_link(
            href: "http://www.example.com",
          )
        end

        context "when using tokens" do
          before do
            component.update_setting(
              :logged_in_mobile_url,
              "http://www.example.com/$username/$user_id",
            )
            component.save!
          end

          it "interpolates tokens" do
            visit("/")

            expect(page.find(".home-logo-wrapper-outlet")).to have_link(
              href: "http://www.example.com/#{user.username}/#{user.id}",
            )
          end
        end
      end

      context "when the logged_in_mobile_url is not set" do
        it "defaults to root" do
          visit("/")

          expect(page.find(".home-logo-wrapper-outlet")).to have_link(href: "/")
        end
      end
    end
  end
end
