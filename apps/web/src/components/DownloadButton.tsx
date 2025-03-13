"use client";

import Link from "next/link";
import { PushableButton } from "./PushableButton";

interface DownloadButtonProps {
  className?: string;
}

export function DownloadButton({ className }: DownloadButtonProps) {
  return (
    <Link
      href="https://apps.apple.com/app/year-progress-tracker/id6741092986"
      target="_blank"
    >
      <PushableButton className={className}>Download for macOS</PushableButton>
    </Link>
  );
}
