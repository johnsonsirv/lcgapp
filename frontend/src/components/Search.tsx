'use client'

import { useState, useEffect } from 'react'

interface Participant {
  id: string
  first_name: string
  last_name: string
  email: string
  attended: boolean
  phone_number: string
  event_id: string
}

export default function Search() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState<Participant[]>([])
  const [isUpdating, setIsUpdating] = useState<string | null>(null)
  const ip = "http://192.168.0.133:3000"

  const handleSearch = async () => {
    try {
      const response = await fetch(`${ip}/api/v1/participants/search?query=${query}`)
    //   const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/participants/search?query=${query}`)
      const data = await response.json()
      
      setResults(data.data)
    } catch (error) {
      console.error('Search error:', error)
    }
  }

  const handleToggleAttendance = async (id: string) => {
    try {
        setIsUpdating(id)

        const response = await fetch(`${ip}/api/v1/participants/${id}/toggle_attended`, {
    //   const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}}/api/v1/participants/${id}/toggle_attended`, {
        method: 'PATCH'
      })
      const { data } = await response.json()
      
      // Update the results array with the new attendance status
      setResults(results.map(participant => 
        participant.id === id 
          ? { ...participant, attended: data.attended }
          : participant
      ))
    } catch (error) {
      console.error('Toggle attendance error:', error)
    } finally {
        setIsUpdating(null)
    }
  }

  useEffect(() => {
    if (query.length >= 5) {
      const timeoutId = setTimeout(() => {
        handleSearch()
      }, 500) // 500ms delay

      return () => clearTimeout(timeoutId)
    }
  }, [query])

return (
    <div className="h-screen flex flex-col">
      {/* Fixed Search Section */}
      <div className="bg-white py-8 px-4 sm:px-6 lg:px-8 border-b">
        <div className="max-w-7xl mx-auto">
          <div className="flex flex-col gap-4">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') {
                  handleSearch()
                }
              }}
              placeholder="Search by phone number or first name..."
              className="w-full p-6 text-4xl bg-gray-200
                border rounded-xl outline-none font-sans
                h-30 text-center placeholder:text-4xl placeholder:text-gray-400"
              title="Search by phone number or first name..."
            />
            <div className="flex justify-center">
              <button
                onClick={handleSearch}
                className="w-1/3 px-8 py-3 bg-blue-800 text-white text-2xl rounded-lg hover:bg-blue-900 transition-colors"
              >
                Search
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Scrollable Results Section */}
      <div className="flex-1 overflow-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="max-w-7xl mx-auto">
          <div className="flex flex-col gap-8">
            {results.length === 0 ? (
              <div className="text-center py-8">
                <p className="text-2xl text-gray-500">No participant found for the search query</p>
              </div>
            ) : results.map((participant) => (
                <div key={participant.id} className="w-full p-6 border rounded-lg shadow">
                  <div className="flex items-start gap-6">
                    {/* Avatar */}
                    <div className="w-20 h-20 bg-gray-300 rounded-full flex items-center justify-center flex-shrink-0">
                      <svg className="w-12 h-12 text-gray-600" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8c0 2.208-1.79 4-3.998 4-2.208 0-3.998-1.792-3.998-4s1.79-4 3.998-4c2.208 0 3.998 1.792 3.998 4z" />
                      </svg>
                    </div>

                    {/* User Information */}
                    <div className="flex-grow">
                      <h3 className="text-3xl font-semibold capitalize">
                        {participant.first_name.toLowerCase()} {participant.last_name.toLowerCase()}
                      </h3>
                      <p className="text-gray-600 text-xl mt-2">{participant.phone_number} |  <span className="text-red-600 text-xl">{participant.email}</span></p>
                      <div className="mt-6 flex items-center justify-between">
                        <span className={`px-4 py-2 rounded text-lg font-medium ${
                          participant.attended 
                            ? 'bg-green-100 text-green-800' 
                            : 'bg-yellow-100 text-yellow-800'
                        }`}>
                          {participant.attended ? 'Attended' : 'Registered'}
                        </span>
                        {!participant.attended && (
                          <button
                            id={`attend-btn-${participant.id}`}
                            onClick={() => handleToggleAttendance(participant.id)}
                            disabled={isUpdating === participant.id}
                            className={`px-6 py-3 bg-blue-500 text-white
                                    rounded-lg hover:bg-blue-600 text-lg
                                    ${isUpdating === participant.id
                                        ? 'bg-gray-400 hover:bg-gray-400 cursor-not-allowed' 
                                        : 'bg-blue-500 hover:bg-blue-600'}`}
                          >
                            {isUpdating === participant.id ? 'Updating...' : 'Mark Attended'}
                          </button>
                         )}
                      </div>
                    </div>
                  </div>
                </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}