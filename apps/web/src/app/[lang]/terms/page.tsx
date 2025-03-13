export async function generateStaticParams() {
  return [{ lang: "en" }, { lang: "ko" }];
}

export default async function Terms() {
  return (
    <div className="container mx-auto px-4 py-8 max-w-4xl">
      <h1 className="text-3xl font-bold mb-6">Terms of Service</h1>

      <div className="space-y-6">
        <section>
          <h2 className="text-2xl font-semibold mb-3">1. Acceptance of Terms</h2>
          <p className="text-gray-700">
            By accessing and using Year Progress (&ldquo;the Service&rdquo;), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the Service.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">2. Description of Service</h2>
          <p className="text-gray-700">
            Year Progress is a service that provides users with a visual representation of the current progress of the year. The Service is provided &ldquo;as is&rdquo; and may be modified or updated from time to time.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">3. Use of Service</h2>
          <p className="text-gray-700">
            You agree to use the Service only for lawful purposes and in accordance with these Terms. You agree not to use the Service:
          </p>
          <ul className="list-disc pl-6 mt-2 text-gray-700">
            <li>In any way that violates any applicable laws or regulations</li>
            <li>To attempt to interfere with the proper functioning of the Service</li>
            <li>To engage in any automated use of the system</li>
          </ul>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">4. Intellectual Property</h2>
          <p className="text-gray-700">
            The Service and its original content, features, and functionality are owned by Year Progress and are protected by international copyright, trademark, and other intellectual property laws.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">5. Disclaimer of Warranties</h2>
          <p className="text-gray-700">
            The Service is provided on an &ldquo;as is&rdquo; and &ldquo;as available&rdquo; basis. Year Progress makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">6. Limitation of Liability</h2>
          <p className="text-gray-700">
            In no event shall Year Progress be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">7. Changes to Terms</h2>
          <p className="text-gray-700">
            We reserve the right to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days&apos; notice prior to any new terms taking effect.
          </p>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-3">8. Contact Us</h2>
          <p className="text-gray-700">
            If you have any questions about these Terms, please contact us at{" "}
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
          Last updated: January 29, 2025
        </footer>
      </div>
    </div>
  );
}
