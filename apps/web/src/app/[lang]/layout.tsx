import "./globals.css";

import type { Metadata } from "next";
import { getDictionary } from "@/dictionaries";
import type { Locale } from "@/middleware";
import Link from "next/link";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ lang: Locale }>;
}): Promise<Metadata> {
  const { lang } = await params;
  const { home } = await getDictionary(lang);

  return {
    title: {
      template: `%s | ${home.title}`,
      default: home.title,
    },
    description: home.description,
    openGraph: {
      title: home.title,
      description: home.description,
      images: [`/opengraph-image-${lang}.jpg`],
    },
    twitter: {
      card: "summary_large_image",
      images: [`/opengraph-image-${lang}.jpg`],
    },
  };
}

export default async function RootLayout({
  children,
  params,
}: Readonly<{
  children: React.ReactNode;
  params: Promise<{ lang: Locale }>;
}>) {
  const { lang } = await params;
  const { navigation } = await getDictionary(lang);

  return (
    <html lang={lang}>
      <body className="antialiased">
        {children}
        <footer className="mt-24 pb-12 text-center text-sm text-gray-500 dark:text-gray-400">
          &copy; {new Date().getFullYear()} Year Progress App. All rights
          reserved. •{" "}
          <Link href="/privacy" className="hover:underline">
            {navigation.privacy}
          </Link>{" "}
          •{" "}
          <Link href="/terms" className="hover:underline">
            {navigation.terms}
          </Link>
        </footer>
      </body>
    </html>
  );
}
