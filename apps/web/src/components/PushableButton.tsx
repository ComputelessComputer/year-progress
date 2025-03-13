import { type ReactNode, type ButtonHTMLAttributes } from "react";

interface PushableButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  baseColor?: string; // HSL color for the base/shadow
  frontColor?: string; // HSL color for the front button face
}

export function PushableButton({
  children,
  onClick,
  baseColor = "hsl(220, 100%, 32%)",
  frontColor = "hsl(210, 100%, 47%)",
  className = "",
  ...props
}: PushableButtonProps) {
  return (
    <button
      className={`relative rounded-xl border-none p-0 ${
        !props.disabled ? "cursor-pointer" : "cursor-not-allowed"
      } outline-offset-4 ${
        !props.disabled ? "active:transform" : ""
      } ${className}`}
      style={{
        background: props.disabled ? "hsl(0, 0%, 70%)" : baseColor,
      }}
      onClick={onClick}
      {...props}
    >
      <span
        className={`block px-[42px] py-3 rounded-xl text-xl text-white ${
          !props.disabled
            ? "translate-y-[-6px] active:translate-y-[-2px]"
            : "translate-y-[-2px]"
        } transition-transform duration-50`}
        style={{
          background: props.disabled ? "hsl(0, 0%, 80%)" : frontColor,
          opacity: props.disabled ? 0.7 : 1,
        }}
      >
        {children}
      </span>
    </button>
  );
}
