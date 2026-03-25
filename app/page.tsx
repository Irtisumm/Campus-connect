'use client';

import React, { useState } from 'react';
import { Heart, MapPin, Calendar, AlertCircle, Lock, Users, Search, Bell, Shield } from 'lucide-react';

export default function CampusConnectDesign() {
  const [activeTab, setActiveTab] = useState('overview');
  const [showScreen, setShowScreen] = useState('home');

  const colors = {
    red: '#C41E3A',
    redDark: '#8B1428',
    redLight: '#E8475F',
    gold: '#F8D49B',
    goldDark: '#E8B96A',
    cream: '#F8E6CB',
    bg: '#F0E8D8',
    card: '#FFFFFF',
    textPrimary: '#2B3A4A',
    textSecondary: '#4E6272',
    textMuted: '#7FA3B5',
    success: '#E8475F',
    warning: '#E8B96A',
    danger: '#D65E5E',
  };

  const NavTab = ({ id, label }) => (
    <button
      onClick={() => setShowScreen(id)}
      className={`px-4 py-3 rounded-lg font-semibold text-sm transition-all ${
        showScreen === id
          ? 'bg-red-600 text-white'
          : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
      }`}
      style={
        showScreen === id
          ? { backgroundColor: colors.red, color: 'white' }
          : {}
      }
    >
      {label}
    </button>
  );

  // ─────────────────────────────────────────────────────────────
  // HOME SCREEN (Hub View)
  // ─────────────────────────────────────────────────────────────
  const HomeScreen = () => (
    <div className="w-full max-w-4xl mx-auto" style={{ backgroundColor: colors.bg }}>
      {/* Header */}
      <div
        style={{ background: `linear-gradient(135deg, ${colors.red}, ${colors.redLight})` }}
        className="text-white px-6 py-6 rounded-b-xl shadow-lg"
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div
              className="w-10 h-10 rounded-lg flex items-center justify-center"
              style={{ backgroundColor: 'rgba(255,255,255,0.2)' }}
            >
              <span className="text-xl">🏫</span>
            </div>
            <div>
              <h1 className="font-bold text-lg">Campus Connect</h1>
              <p className="text-xs opacity-90">City University Malaysia</p>
            </div>
          </div>
          <div className="flex gap-2">
            <button
              className="p-2 rounded-lg"
              style={{ backgroundColor: 'rgba(255,255,255,0.2)' }}
            >
              <Bell size={20} />
            </button>
            <button
              className="px-3 py-1 rounded-full text-xs font-bold"
              style={{ backgroundColor: colors.gold, color: '#7A5B00' }}
            >
              Student
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="p-6 space-y-6">
        {/* Feature Grid */}
        <div className="grid grid-cols-2 gap-4">
          {[
            { icon: '🔍', title: 'Lost & Found', desc: 'Report & find items' },
            { icon: '⚠️', title: 'Issues', desc: 'Campus problems' },
            { icon: '📅', title: 'Events', desc: 'Campus events' },
            { icon: '🔐', title: 'Lockers', desc: 'Locker booking' },
          ].map((item, i) => (
            <div
              key={i}
              className="p-4 rounded-2xl border-2 flex flex-col items-center justify-center text-center cursor-pointer hover:shadow-md transition-all"
              style={{
                backgroundColor: colors.card,
                borderColor: `${colors.red}20`,
              }}
              onClick={() => setShowScreen(['lostfound', 'issues', 'events', 'lockers'][i])}
            >
              <div className="text-4xl mb-2">{item.icon}</div>
              <h3 className="font-bold text-sm">{item.title}</h3>
              <p className="text-xs" style={{ color: colors.textMuted }}>
                {item.desc}
              </p>
            </div>
          ))}
        </div>

        {/* Quick Actions */}
        <div className="space-y-3">
          <h2 className="font-bold" style={{ color: colors.textPrimary }}>
            Quick Actions
          </h2>
          <button
            className="w-full py-3 px-4 rounded-lg font-semibold text-white transition-all hover:opacity-90"
            style={{ backgroundColor: colors.red }}
            onClick={() => setShowScreen('reportlost')}
          >
            Report Lost Item
          </button>
          <button
            className="w-full py-3 px-4 rounded-lg font-semibold transition-all hover:opacity-90"
            style={{ backgroundColor: colors.cream, color: colors.textPrimary }}
            onClick={() => setShowScreen('reportissue')}
          >
            Report Campus Issue
          </button>
        </div>

        {/* Recent Activity */}
        <div className="space-y-3">
          <h2 className="font-bold" style={{ color: colors.textPrimary }}>
            Recent Activity
          </h2>
          <div
            className="p-4 rounded-lg border-l-4"
            style={{ backgroundColor: colors.card, borderColor: colors.redLight }}
          >
            <p className="text-sm font-semibold" style={{ color: colors.textPrimary }}>
              Match Found for Your Lost Item
            </p>
            <p className="text-xs mt-1" style={{ color: colors.textMuted }}>
              Blue Samsung Galaxy S23 - 2 hours ago
            </p>
          </div>
        </div>
      </div>
    </div>
  );

  // ─────────────────────────────────────────────────────────────
  // LOST & FOUND HUB
  // ─────────────────────────────────────────────────────────────
  const LostFoundScreen = () => (
    <div className="w-full max-w-4xl mx-auto p-6" style={{ backgroundColor: colors.bg, minHeight: '600px' }}>
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold" style={{ color: colors.textPrimary }}>
          Lost & Found
        </h1>
        <p className="text-sm mt-1" style={{ color: colors.textMuted }}>
          Browse reported items and find what you're looking for
        </p>
      </div>

      {/* Tabs */}
      <div className="flex gap-3 mb-6 overflow-x-auto">
        {['All Items', 'My Lost', 'My Found'].map((tab) => (
          <button
            key={tab}
            className="px-4 py-2 rounded-lg whitespace-nowrap font-semibold text-sm"
            style={{
              backgroundColor: colors.card,
              color: colors.textPrimary,
              borderBottom: `3px solid ${colors.red}`,
            }}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Item Cards */}
      <div className="grid gap-4">
        {[
          {
            type: 'Lost',
            title: 'Blue Samsung Galaxy S23',
            category: 'Phone',
            where: 'Block A, Level 3',
            when: '2026-03-20',
            status: 'Active',
            match: true,
          },
          {
            type: 'Found',
            title: 'Black Android Phone',
            category: 'Phone',
            where: 'Block A Corridor',
            when: '2026-03-21',
            status: 'In Inventory',
          },
          {
            type: 'Lost',
            title: 'Student ID Card',
            category: 'ID Card',
            where: 'Library',
            when: '2026-03-18',
            status: 'Matched',
            match: true,
          },
        ].map((item, i) => (
          <div
            key={i}
            className="p-4 rounded-xl border-2 hover:shadow-md transition-all cursor-pointer"
            style={{
              backgroundColor: colors.card,
              borderColor: `${colors.red}20`,
            }}
          >
            <div className="flex justify-between items-start">
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-2">
                  <span
                    className="px-3 py-1 rounded-full text-xs font-bold"
                    style={{
                      backgroundColor: item.type === 'Lost' ? `${colors.red}20` : `${colors.gold}20`,
                      color: item.type === 'Lost' ? colors.red : colors.goldDark,
                    }}
                  >
                    {item.type}
                  </span>
                  <span className="text-xs" style={{ color: colors.textMuted }}>
                    {item.category}
                  </span>
                </div>
                <h3 className="font-bold" style={{ color: colors.textPrimary }}>
                  {item.title}
                </h3>
                <div className="flex items-center gap-4 mt-2 text-xs" style={{ color: colors.textMuted }}>
                  <span>📍 {item.where}</span>
                  <span>📅 {item.when}</span>
                </div>
              </div>
              {item.match && (
                <div className="ml-4">
                  <div
                    className="px-3 py-1 rounded-lg text-xs font-bold"
                    style={{ backgroundColor: `${colors.success}20`, color: colors.success }}
                  >
                    Match Found
                  </div>
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // ─────────────────────────────────────────────────────────────
  // REPORT LOST ITEM
  // ─────────────────────────────────────────────────────────────
  const ReportLostScreen = () => (
    <div className="w-full max-w-4xl mx-auto p-6" style={{ backgroundColor: colors.bg }}>
      <h1 className="text-2xl font-bold mb-2" style={{ color: colors.textPrimary }}>
        Report Lost Item
      </h1>
      <p className="text-sm mb-6" style={{ color: colors.textMuted }}>
        Help us find your lost item
      </p>

      <div className="space-y-5" style={{ backgroundColor: colors.card, padding: '24px', borderRadius: '16px' }}>
        {/* Title */}
        <div>
          <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
            Item Title
          </label>
          <input
            type="text"
            placeholder="e.g., Blue Samsung Galaxy S23"
            className="w-full mt-2 p-3 border-2 rounded-lg"
            style={{ borderColor: `${colors.red}30`, color: colors.textPrimary }}
          />
        </div>

        {/* Category */}
        <div>
          <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
            Category
          </label>
          <div className="grid grid-cols-3 gap-3 mt-2">
            {['Phone', 'Wallet', 'Keys', 'ID Card', 'Bag', 'Other'].map((cat) => (
              <button
                key={cat}
                className="p-3 rounded-lg border-2 font-semibold text-sm"
                style={{
                  borderColor: `${colors.red}20`,
                  backgroundColor: cat === 'Phone' ? colors.red : colors.card,
                  color: cat === 'Phone' ? 'white' : colors.textPrimary,
                }}
              >
                {cat}
              </button>
            ))}
          </div>
        </div>

        {/* Location & Date */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
              Where Lost?
            </label>
            <input
              type="text"
              placeholder="Location"
              className="w-full mt-2 p-3 border-2 rounded-lg"
              style={{ borderColor: `${colors.red}30` }}
            />
          </div>
          <div>
            <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
              When Lost?
            </label>
            <input
              type="date"
              className="w-full mt-2 p-3 border-2 rounded-lg"
              style={{ borderColor: `${colors.red}30` }}
            />
          </div>
        </div>

        {/* Description */}
        <div>
          <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
            Description
          </label>
          <textarea
            placeholder="Describe the item in detail (color, brand, special marks, etc.)"
            className="w-full mt-2 p-3 border-2 rounded-lg h-24"
            style={{ borderColor: `${colors.red}30` }}
          />
        </div>

        {/* Submit */}
        <button
          className="w-full py-3 rounded-lg font-bold text-white hover:opacity-90 transition-all"
          style={{ backgroundColor: colors.red }}
        >
          Submit Report
        </button>
      </div>
    </div>
  );

  // ─────────────────────────────────────────────────────────────
  // ISSUES HUB
  // ─────────────────────────────────────────────────────────────
  const IssuesScreen = () => (
    <div className="w-full max-w-4xl mx-auto p-6" style={{ backgroundColor: colors.bg }}>
      <h1 className="text-2xl font-bold mb-2" style={{ color: colors.textPrimary }}>
        Campus Issues
      </h1>
      <p className="text-sm mb-6" style={{ color: colors.textMuted }}>
        Report and track campus facility problems
      </p>

      <div className="space-y-4">
        {[
          {
            title: 'Broken AC in Lecture Hall A2',
            category: 'Facilities',
            status: 'In Progress',
            location: 'Block A, Level 2',
            date: '2026-03-10',
          },
          {
            title: 'Wifi down at Study Area',
            category: 'IT',
            status: 'New',
            location: 'Library Level 3',
            date: '2026-03-23',
          },
          {
            title: 'Waterlogging at Entrance',
            category: 'Safety',
            status: 'Triaged',
            location: 'Main Entrance',
            date: '2026-03-21',
          },
        ].map((issue, i) => (
          <div
            key={i}
            className="p-4 rounded-xl border-2 hover:shadow-md transition-all"
            style={{
              backgroundColor: colors.card,
              borderColor: `${colors.red}20`,
            }}
          >
            <div className="flex items-start justify-between">
              <div className="flex-1">
                <h3 className="font-bold" style={{ color: colors.textPrimary }}>
                  {issue.title}
                </h3>
                <div className="flex gap-3 mt-2 text-xs" style={{ color: colors.textMuted }}>
                  <span>🏷️ {issue.category}</span>
                  <span>📍 {issue.location}</span>
                </div>
              </div>
              <span
                className="px-3 py-1 rounded-full text-xs font-bold"
                style={{
                  backgroundColor:
                    issue.status === 'In Progress'
                      ? `${colors.warning}20`
                      : `${colors.danger}20`,
                  color:
                    issue.status === 'In Progress' ? colors.warning : colors.danger,
                }}
              >
                {issue.status}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // ─────────────────────────────────────────────────────────────
  // EVENTS HUB
  // ─────────────────────────────────────────────────────────────
  const EventsScreen = () => (
    <div className="w-full max-w-4xl mx-auto p-6" style={{ backgroundColor: colors.bg }}>
      <h1 className="text-2xl font-bold mb-2" style={{ color: colors.textPrimary }}>
        Campus Events
      </h1>
      <p className="text-sm mb-6" style={{ color: colors.textMuted }}>
        Discover upcoming events on campus
      </p>

      <div className="space-y-4">
        {[
          {
            title: 'Final Semester Convocation 2026',
            date: '2026-04-10',
            time: '09:00 AM',
            location: 'Main Auditorium',
            category: 'Academic',
          },
          {
            title: 'Inter-Faculty Badminton Tournament',
            date: '2026-03-28',
            time: '08:00 AM',
            location: 'Sports Complex – Court 1',
            category: 'Sport',
          },
          {
            title: 'AI & Machine Learning Workshop',
            date: '2026-03-26',
            time: '02:00 PM',
            location: 'Block C, Lab C3-01',
            category: 'Academic',
          },
        ].map((event, i) => (
          <div
            key={i}
            className="p-4 rounded-xl border-2 hover:shadow-md transition-all"
            style={{
              backgroundColor: colors.card,
              borderColor: `${colors.red}20`,
            }}
          >
            <div className="flex gap-4">
              <div
                className="w-12 h-12 rounded-lg flex items-center justify-center flex-shrink-0"
                style={{ backgroundColor: `${colors.red}20` }}
              >
                <Calendar size={20} style={{ color: colors.red }} />
              </div>
              <div className="flex-1">
                <h3 className="font-bold" style={{ color: colors.textPrimary }}>
                  {event.title}
                </h3>
                <div className="flex gap-3 mt-2 text-xs" style={{ color: colors.textMuted }}>
                  <span>📅 {event.date}</span>
                  <span>🕐 {event.time}</span>
                  <span>📍 {event.location}</span>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // ─────────────────────────────────────────────────────────────
  // LOCKERS HUB
  // ─────────────────────────────────────────────────────────────
  const LockersScreen = () => (
    <div className="w-full max-w-4xl mx-auto p-6" style={{ backgroundColor: colors.bg }}>
      <h1 className="text-2xl font-bold mb-2" style={{ color: colors.textPrimary }}>
        Locker Booking
      </h1>
      <p className="text-sm mb-6" style={{ color: colors.textMuted }}>
        Browse and book available lockers
      </p>

      <div className="space-y-4">
        {[
          {
            id: 'LK-A02',
            location: 'Block A, Level 1',
            status: 'Active',
            daysLeft: 98,
            endDate: '2026-06-30',
          },
          {
            id: 'LK-A01',
            location: 'Block A, Level 1',
            status: 'Available',
          },
          {
            id: 'LK-B02',
            location: 'Block B, Level 2',
            status: 'Active',
            daysLeft: 98,
            endDate: '2026-06-30',
          },
        ].map((locker, i) => (
          <div
            key={i}
            className="p-4 rounded-xl border-2 hover:shadow-md transition-all"
            style={{
              backgroundColor: colors.card,
              borderColor: `${colors.red}20`,
            }}
          >
            <div className="flex items-center justify-between">
              <div>
                <div className="flex items-center gap-2 mb-1">
                  <Lock size={16} style={{ color: colors.red }} />
                  <h3 className="font-bold" style={{ color: colors.textPrimary }}>
                    {locker.id}
                  </h3>
                </div>
                <p className="text-sm" style={{ color: colors.textMuted }}>
                  {locker.location}
                </p>
              </div>
              <div className="text-right">
                <span
                  className="px-3 py-1 rounded-full text-xs font-bold"
                  style={{
                    backgroundColor:
                      locker.status === 'Available'
                        ? `${colors.success}20`
                        : `${colors.warning}20`,
                    color:
                      locker.status === 'Available' ? colors.success : colors.warning,
                  }}
                >
                  {locker.status}
                </span>
                {locker.daysLeft && (
                  <p className="text-xs mt-2" style={{ color: colors.textMuted }}>
                    {locker.daysLeft} days left
                  </p>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  // ─────────────────────────────────────────────────────────────
  // REPORT ISSUE SCREEN
  // ─────────────────────────────────────────────────────────────
  const ReportIssueScreen = () => (
    <div className="w-full max-w-4xl mx-auto p-6" style={{ backgroundColor: colors.bg }}>
      <h1 className="text-2xl font-bold mb-2" style={{ color: colors.textPrimary }}>
        Report Campus Issue
      </h1>
      <p className="text-sm mb-6" style={{ color: colors.textMuted }}>
        Help improve campus by reporting problems
      </p>

      <div className="space-y-5" style={{ backgroundColor: colors.card, padding: '24px', borderRadius: '16px' }}>
        {/* Title */}
        <div>
          <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
            Issue Title
          </label>
          <input
            type="text"
            placeholder="e.g., Broken AC in Lecture Hall A2"
            className="w-full mt-2 p-3 border-2 rounded-lg"
            style={{ borderColor: `${colors.red}30` }}
          />
        </div>

        {/* Category */}
        <div>
          <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
            Category
          </label>
          <div className="grid grid-cols-3 gap-3 mt-2">
            {['Facilities', 'IT', 'Safety', 'Cleanliness', 'Other'].map((cat) => (
              <button
                key={cat}
                className="p-3 rounded-lg border-2 font-semibold text-sm"
                style={{
                  borderColor: `${colors.red}20`,
                  backgroundColor: cat === 'Facilities' ? colors.red : colors.card,
                  color: cat === 'Facilities' ? 'white' : colors.textPrimary,
                }}
              >
                {cat}
              </button>
            ))}
          </div>
        </div>

        {/* Location */}
        <div>
          <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
            Location
          </label>
          <input
            type="text"
            placeholder="Where is the issue?"
            className="w-full mt-2 p-3 border-2 rounded-lg"
            style={{ borderColor: `${colors.red}30` }}
          />
        </div>

        {/* Description */}
        <div>
          <label className="text-xs font-bold" style={{ color: colors.textMuted }}>
            Description
          </label>
          <textarea
            placeholder="Describe the issue in detail"
            className="w-full mt-2 p-3 border-2 rounded-lg h-24"
            style={{ borderColor: `${colors.red}30` }}
          />
        </div>

        {/* Submit */}
        <button
          className="w-full py-3 rounded-lg font-bold text-white hover:opacity-90 transition-all"
          style={{ backgroundColor: colors.red }}
        >
          Submit Issue Report
        </button>
      </div>
    </div>
  );

  // ─────────────────────────────────────────────────────────────
  // DESIGN SYSTEM PAGE
  // ─────────────────────────────────────────────────────────────
  const DesignSystemScreen = () => (
    <div className="w-full max-w-4xl mx-auto p-6 space-y-8">
      <div>
        <h1 className="text-3xl font-bold mb-2" style={{ color: colors.textPrimary }}>
          Campus Connect - Design System
        </h1>
        <p className="text-lg" style={{ color: colors.textMuted }}>
          For City University Malaysia
        </p>
      </div>

      {/* Color Palette */}
      <div className="space-y-4">
        <h2 className="text-2xl font-bold" style={{ color: colors.textPrimary }}>
          Color Palette
        </h2>
        <div className="grid grid-cols-3 gap-4">
          {[
            { name: 'Primary Red', hex: colors.red },
            { name: 'Red Dark', hex: colors.redDark },
            { name: 'Red Light', hex: colors.redLight },
            { name: 'Gold', hex: colors.gold },
            { name: 'Gold Dark', hex: colors.goldDark },
            { name: 'Background', hex: colors.bg },
            { name: 'Card White', hex: colors.card },
            { name: 'Text Primary', hex: colors.textPrimary },
            { name: 'Text Muted', hex: colors.textMuted },
          ].map((color) => (
            <div key={color.name} className="text-center">
              <div
                className="w-full h-32 rounded-lg mb-3 border-2 flex items-center justify-center font-bold text-white"
                style={{ backgroundColor: color.hex, borderColor: `${color.hex}50` }}
              >
                <button
                  className="text-sm bg-black bg-opacity-30 px-3 py-1 rounded hover:bg-opacity-50"
                  onClick={() => {
                    navigator.clipboard.writeText(color.hex);
                  }}
                >
                  Copy
                </button>
              </div>
              <p className="text-sm font-semibold">{color.name}</p>
              <p className="text-xs" style={{ color: colors.textMuted }}>
                {color.hex}
              </p>
            </div>
          ))}
        </div>
      </div>

      {/* Typography */}
      <div className="space-y-4">
        <h2 className="text-2xl font-bold" style={{ color: colors.textPrimary }}>
          Typography
        </h2>
        <div className="space-y-4" style={{ backgroundColor: colors.card, padding: '24px', borderRadius: '12px' }}>
          <div>
            <p className="text-xs font-semibold" style={{ color: colors.textMuted }}>
              Font Family
            </p>
            <p className="text-lg font-bold mt-1" style={{ color: colors.textPrimary }}>
              Inter
            </p>
          </div>
          <div>
            <p className="text-xs font-semibold" style={{ color: colors.textMuted }}>
              Heading (24px, Bold)
            </p>
            <h1 className="text-2xl font-bold mt-2" style={{ color: colors.textPrimary }}>
              Heading Example
            </h1>
          </div>
          <div>
            <p className="text-xs font-semibold" style={{ color: colors.textMuted }}>
              Body (14px, Regular)
            </p>
            <p className="text-sm mt-2" style={{ color: colors.textPrimary }}>
              This is body text. It should be readable and clear for all users.
            </p>
          </div>
          <div>
            <p className="text-xs font-semibold" style={{ color: colors.textMuted }}>
              Small (12px, Medium)
            </p>
            <p className="text-xs mt-2 font-medium" style={{ color: colors.textMuted }}>
              This is small text used for labels and hints.
            </p>
          </div>
        </div>
      </div>

      {/* Components */}
      <div className="space-y-4">
        <h2 className="text-2xl font-bold" style={{ color: colors.textPrimary }}>
          Button Styles
        </h2>
        <div className="space-y-3">
          <button
            className="w-full py-3 rounded-lg font-bold text-white"
            style={{ backgroundColor: colors.red }}
          >
            Primary Button
          </button>
          <button
            className="w-full py-3 rounded-lg font-bold border-2"
            style={{ color: colors.red, borderColor: colors.red, backgroundColor: 'transparent' }}
          >
            Secondary Button
          </button>
          <button
            className="w-full py-3 rounded-lg font-bold"
            style={{ backgroundColor: colors.gold, color: colors.goldDark }}
          >
            Accent Button
          </button>
        </div>
      </div>

      {/* Status Badges */}
      <div className="space-y-4">
        <h2 className="text-2xl font-bold" style={{ color: colors.textPrimary }}>
          Status Badges
        </h2>
        <div className="flex flex-wrap gap-3">
          {[
            { label: 'Active', bg: `${colors.success}20`, color: colors.success },
            { label: 'In Progress', bg: `${colors.warning}20`, color: colors.warning },
            { label: 'Pending', bg: `${colors.gold}20`, color: colors.goldDark },
            { label: 'Closed', bg: `${colors.textMuted}20`, color: colors.textMuted },
          ].map((badge) => (
            <span
              key={badge.label}
              className="px-4 py-2 rounded-full text-sm font-bold"
              style={{ backgroundColor: badge.bg, color: badge.color }}
            >
              {badge.label}
            </span>
          ))}
        </div>
      </div>

      {/* Spacing & Border Radius */}
      <div className="space-y-4">
        <h2 className="text-2xl font-bold" style={{ color: colors.textPrimary }}>
          Specifications
        </h2>
        <div
          className="space-y-3"
          style={{ backgroundColor: colors.card, padding: '24px', borderRadius: '12px' }}
        >
          <div>
            <p className="text-sm font-semibold" style={{ color: colors.textMuted }}>
              Border Radius
            </p>
            <p className="text-sm mt-1" style={{ color: colors.textPrimary }}>
              Small: 8px | Medium: 12px | Large: 16px | Extra Large: 18px
            </p>
          </div>
          <div>
            <p className="text-sm font-semibold" style={{ color: colors.textMuted }}>
              Spacing Scale
            </p>
            <p className="text-sm mt-1" style={{ color: colors.textPrimary }}>
              4px, 8px, 12px, 16px, 20px, 24px, 32px, 40px, 48px
            </p>
          </div>
          <div>
            <p className="text-sm font-semibold" style={{ color: colors.textMuted }}>
              Shadow
            </p>
            <p className="text-sm mt-1" style={{ color: colors.textPrimary }}>
              Subtle: blur 12px, offset 0 3px, opacity 12% | Bold: blur 20px, offset 0 -4px, opacity 12%
            </p>
          </div>
        </div>
      </div>
    </div>
  );

  // ─────────────────────────────────────────────────────────────
  // RENDER CONTENT
  // ─────────────────────────────────────────────────────────────
  const renderScreen = () => {
    switch (showScreen) {
      case 'home':
        return <HomeScreen />;
      case 'lostfound':
        return <LostFoundScreen />;
      case 'reportlost':
        return <ReportLostScreen />;
      case 'issues':
        return <IssuesScreen />;
      case 'reportissue':
        return <ReportIssueScreen />;
      case 'events':
        return <EventsScreen />;
      case 'lockers':
        return <LockersScreen />;
      case 'design':
        return <DesignSystemScreen />;
      default:
        return <HomeScreen />;
    }
  };

  return (
    <div style={{ backgroundColor: '#F0E8D8', minHeight: '100vh' }} className="py-8">
      <div className="max-w-6xl mx-auto px-4">
        {/* Navigation */}
        <div className="mb-8 flex flex-wrap gap-2 justify-center">
          <NavTab id="home" label="Home" />
          <NavTab id="lostfound" label="Lost & Found" />
          <NavTab id="reportlost" label="Report Lost" />
          <NavTab id="issues" label="Issues" />
          <NavTab id="reportissue" label="Report Issue" />
          <NavTab id="events" label="Events" />
          <NavTab id="lockers" label="Lockers" />
          <NavTab id="design" label="Design System" />
        </div>

        {/* Content */}
        <div className="bg-white rounded-xl shadow-lg overflow-hidden">
          {renderScreen()}
        </div>

        {/* Info */}
        <div className="mt-8 text-center">
          <p className="text-sm" style={{ color: colors.textMuted }}>
            Campus Connect - Design Mockups for Figma Presentation
          </p>
          <p className="text-xs mt-1" style={{ color: colors.textMuted }}>
            Right-click and screenshot any screen above to use in your Figma design
          </p>
        </div>
      </div>
    </div>
  );
}
