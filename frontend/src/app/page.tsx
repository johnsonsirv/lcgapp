import Nav from '@/components/Nav'
import Link from 'next/link'

export default function Home() {
  return (
    <div>
      <Nav />
      <main className="max-w-7xl mx-auto py-7">
        <div className="grid grid-cols-2 gap-8 min-h-screen">
          {/* Left Column */}
          <div className="bg-gray-100 overflow-hidden -mt-7 -ml-[max(0px,calc((100vw-1280px)/2))]">
            <img 
              src="/hero-image.jpg" 
              alt="LCG Quick Check"
              className="w-full h-full object-cover"
            />
          </div>

          {/* Right Column */}
          <div className="flex flex-col justify-between py-8">
            <div className="space-y-6">
              <h1 className="text-4xl font-bold">Registration Check-in App</h1>
              <p className="text-xl text-gray-600 leading-relaxed">
                Experience seamless event management with our advanced check-in system. 
                Designed for efficiency and ease of use, LCG Quick Check helps you 
                manage attendees, track participation, and ensure smooth event operations 
                with just a few clicks.
              </p>
              <Link 
                href="/search" 
                className="inline-block px-8 py-4 bg-gray-900 text-white text-xl rounded-lg hover:bg-gray-800 transition-colors"
              >
                Check-In Attendees
              </Link>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}