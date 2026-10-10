import { Arrow, Container, PrimaryButton } from '../components/ui'

export default function NotFound() {
  return (
    <Container className="pt-24 sm:pt-32">
      <div className="font-mono text-[14px] text-faint">404 · NO SIGNAL</div>
      <h1 className="mt-5 text-[40px] leading-[1.05] headline text-ink sm:text-[60px]">This page is dark.</h1>
      <p className="mt-5 max-w-xl text-[18px] leading-relaxed text-dim">The page you were looking for doesn&rsquo;t exist, or it moved.</p>
      <PrimaryButton href="/" className="mt-9">
        Back to the start
        <Arrow />
      </PrimaryButton>
    </Container>
  )
}
