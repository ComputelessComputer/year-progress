export async function generateStaticParams() {
  return [{ lang: "en" }, { lang: "ko" }];
}

export default async function PrivacyPolicy() {
  return (
    <div className="container mx-auto px-4 py-8 max-w-4xl">
      <h1 className="text-3xl font-bold mb-6">Privacy Policy</h1>

      <div className="space-y-6">
        <section>
          <h2 className="text-2xl font-semibold mb-3">Introduction</h2>
          <p className="text-gray-700">
            This Privacy Policy explains how Year Progress (&ldquo;we,&rdquo;
            &ldquo;us,&rdquo; or &ldquo;our&rdquo;) collects, uses, and protects
            your information when you use our website.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">
            Information We Collect
          </h2>
          <p className="text-gray-700">
            We do not collect any personal information from our users. Our
            website is a simple tool that displays the current progress of the
            year and does not require any user data to function.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">Cookies and Analytics</h2>
          <p className="text-gray-700">
            We do not use cookies or any tracking technologies on our website.
            We prioritize your privacy and aim to provide a simple,
            straightforward service without collecting any user data.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">Third-Party Services</h2>
          <p className="text-gray-700">
            Our website does not integrate with any third-party services that
            collect user data.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">
            Changes to This Privacy Policy
          </h2>
          <p className="text-gray-700">
            We may update this Privacy Policy from time to time. Any changes
            will be posted on this page with an updated revision date.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">Contact Us</h2>
          <p className="text-gray-700">
            If you have any questions about this Privacy Policy or need support, please contact
            us at{" "}
            <a
              href="mailto:help@theyearprogress.app"
              className="text-blue-600 hover:underline"
            >
              help@theyearprogress.app
            </a>
            .
          </p>
        </section>

        <footer className="text-sm text-gray-600 mt-8">
          Last updated: January 28, 2025
        </footer>
      </div>
    </div>
  );
}
