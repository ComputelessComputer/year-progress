import { DownloadButton } from "@/components/DownloadButton";
import Image from "next/image";
import Link from "next/link";
import { getDictionary } from "@/dictionaries";
import { Locale } from "@/middleware";

export function generateStaticParams() {
  return [{ lang: "en" }, { lang: "ko" }];
}

export default async function Home({
  params,
}: {
  params: Promise<{ lang: Locale }>;
}) {
  const { lang } = await params;
  const dict = await getDictionary(lang);
  const { features, background, home } = dict;

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-50 to-white">
      <main className="max-w-4xl mx-auto px-4 py-16">
        <div className="text-center">
          <h1 className="text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
            {home.title}
          </h1>

          <p className="mt-6 text-lg leading-8 text-gray-600">
            {home.description}
          </p>

          <Image
            src={`/assets/${lang}.jpg`}
            alt="Year Progress App Screenshot"
            width={800}
            height={500}
            sizes="(max-width: 768px) 100vw, 800px"
            className="mx-auto mt-10 rounded-xl shadow-2xl w-full max-w-[800px] h-auto"
            priority
          />

          <DownloadButton className="mt-8" />
        </div>

        {/* Features Section */}
        <div className="mx-auto mt-32 max-w-2xl">
          <div className="grid grid-cols-1 gap-12 sm:grid-cols-2">
            <div className="relative">
              <dt className="text-lg font-semibold leading-7 text-gray-900">
                {features.simple}
              </dt>
              <dd className="mt-2 text-base text-gray-600">
                {features.simpleDescription}
              </dd>
            </div>
            <div className="relative">
              <dt className="text-lg font-semibold leading-7 text-gray-900">
                {features.multipleTimeScales}
              </dt>
              <dd className="mt-2 text-base text-gray-600">
                {features.multipleTimeScalesDescription}
              </dd>
            </div>
            <div className="relative">
              <dt className="text-lg font-semibold leading-7 text-gray-900">
                {features.menuBarIntegration}
              </dt>
              <dd className="mt-2 text-base text-gray-600">
                {features.menuBarIntegrationDescription}
              </dd>
            </div>
            <div className="relative">
              <dt className="text-lg font-semibold leading-7 text-gray-900">
                {features.nativeMacOSApp}
              </dt>
              <dd className="mt-2 text-base text-gray-600">
                {features.nativeMacOSAppDescription}
              </dd>
            </div>
          </div>
        </div>

        {/* Background Section */}
        <div className="mx-auto max-w-2xl mt-24">
          <h2 className="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl text-center">
            {background.title}
          </h2>
          <div className="mt-10 space-y-8 text-base leading-7 text-gray-600">
            <p>
              {background.description1}
              <Link
                href="https://nat.org"
                target="_blank"
                className="text-blue-600 hover:text-blue-500"
              >
                {background.natFriedmanLink}
              </Link>
              {background.description2}
              <span className="font-semibold text-gray-900">
                {background.quote}
              </span>
              .
            </p>
            <p>{background.description3}</p>
            <p>{background.description4}</p>
          </div>

          <h2 className="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl text-center mt-12 mb-10">
            {background.whyUseThis.title}
          </h2>
          <div className="space-y-8 text-base leading-7 text-gray-600">
            <p>{background.whyUseThis.intro}</p>
            
            <p>{background.whyUseThis.whyItMatters}</p>
            <ul className="list-disc pl-5 space-y-2">
              <li>{background.whyUseThis.benefits.seeTimeDifferently}</li>
              <li>{background.whyUseThis.benefits.stayMotivated}</li>
              <li>{background.whyUseThis.benefits.minimal}</li>
              <li>{background.whyUseThis.benefits.betterThanExisting}</li>
            </ul>
            
            <p>{background.whyUseThis.conclusion}</p>
          </div>
        </div>
      </main>
    </div>
  );
}
