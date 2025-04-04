import Link from 'next/link'

export default function Nav() {
  return (
    <nav className="bg-gray-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-end h-20">
          <div className="flex space-x-12">
            <Link href="/" className="inline-flex items-center px-3 pt-1 text-white text-xl hover:text-gray-300">
              Home
            </Link>
            <Link href="/search" className="inline-flex items-center px-3 pt-1 text-white text-xl hover:text-gray-300">
              Check-In
            </Link>
          </div>
        </div>
      </div>
    </nav>
  )
}