
import React, { useEffect, useState } from 'react';
import CrimeMap from '@/components/CrimeMap';
import KpiCard from '@/components/KpiCard';
import CrimeTrendChart from '@/components/CrimeTrendChart';
import IncidentTypeChart from '@/components/IncidentTypeChart';
import TimeOfDayChart from '@/components/TimeOfDayChart';
import ReportsTable from '@/components/ReportsTable';
import ReportDetail from '@/components/ReportDetail';
import StatusKpiCards from '@/components/StatusKpiCards';
import GlobalFilters from '@/components/GlobalFilters';
import { FilterProvider, useFilters } from '@/contexts/FilterContext';
import { 
  CrimeReport, 
  fetchCrimeReports, 
  getTodayReports, 
  getLastWeekReports, 
  getLastMonthReports,
  getMostFrequentIncidentType,
  getReportsByStatus
} from '@/utils/data';
import { BarChart2, Clock } from 'lucide-react';
import { toast } from 'sonner';

const DashboardContent: React.FC = () => {
  const [reports, setReports] = useState<CrimeReport[]>([]);
  const [filteredReports, setFilteredReports] = useState<CrimeReport[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedReport, setSelectedReport] = useState<CrimeReport | null>(null);
  const [drawerOpen, setDrawerOpen] = useState(false);

  const { 
    dateRange, 
    selectedIncidentTypes, 
    selectedStatuses, 
    applyFilters 
  } = useFilters();

  // Unique incident types and statuses for filters
  const incidentTypes = Array.from(new Set(reports.map(report => report.incident_type)));
  const statuses = ["New", "Under Investigation", "Resolved", "False Report"];

  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      try {
        const data = await fetchCrimeReports();
        setReports(data);
        setFilteredReports(data);
      } catch (error) {
        console.error('Error loading crime reports:', error);
        toast.error('Failed to load crime report data');
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, []);

  // Apply global filters
  useEffect(() => {
    if (!applyFilters) return;

    const newFilteredReports = reports.filter(report => {
      // Filter by date range
      if (dateRange[0] && dateRange[1]) {
        const reportDate = new Date(report.date);
        const startDate = new Date(dateRange[0]);
        const endDate = new Date(dateRange[1]);
        
        // Set time to midnight for proper date comparison
        startDate.setHours(0, 0, 0, 0);
        endDate.setHours(23, 59, 59, 999);
        
        if (reportDate < startDate || reportDate > endDate) {
          return false;
        }
      }

      // Filter by incident type
      if (selectedIncidentTypes.length > 0 && !selectedIncidentTypes.includes(report.incident_type)) {
        return false;
      }

      // Filter by status
      if (selectedStatuses.length > 0 && !selectedStatuses.includes(report.status)) {
        return false;
      }

      return true;
    });

    setFilteredReports(newFilteredReports);
  }, [applyFilters, reports, dateRange, selectedIncidentTypes, selectedStatuses]);

  const handleReportSelect = (report: CrimeReport) => {
    setSelectedReport(report);
    setDrawerOpen(true);
  };

  const handleStatusUpdate = (report: CrimeReport, newStatus: string) => {
    // Update the report in the local state
    const updatedReports = reports.map(r => 
      r.id === report.id ? { ...r, status: newStatus } : r
    );
    setReports(updatedReports);
    setFilteredReports(updatedReports.filter(r => filteredReports.some(fr => fr.id === r.id)));
    
    // If the report is selected, update it
    if (selectedReport && selectedReport.id === report.id) {
      setSelectedReport({ ...selectedReport, status: newStatus });
    }
  };

  // Calculate KPI values
  const todayCount = getTodayReports(filteredReports).length;
  const lastWeekCount = getLastWeekReports(filteredReports).length;
  const lastMonthCount = getLastMonthReports(filteredReports).length;
  const mostFrequentType = getMostFrequentIncidentType(filteredReports);
  
  // Calculate percentage change for week vs previous week
  const weeklyChange = lastWeekCount > 0 
    ? ((lastWeekCount - (lastMonthCount - lastWeekCount) / 3) / ((lastMonthCount - lastWeekCount) / 3) * 100).toFixed(1)
    : '0.0';

  return (
    <div className="min-h-screen flex flex-col w-full relative">
      <header className="sticky top-0 z-40 flex items-center justify-between px-6 py-4 border-b bg-background/95 backdrop-blur-sm supports-[backdrop-filter]:bg-background/80 shadow-sm">
        <h1 className="text-xl font-semibold tracking-tight">Crime Watch Command Center</h1>
        <div className="flex items-center gap-2">
          {/* Placeholder for user menu, notifications, etc. */}
        </div>
      </header>
      
      <main className="flex-1 overflow-container">
        {loading ? (
          <div className="flex items-center justify-center h-[calc(100vh-8rem)]">
            <div className="animate-pulse-soft text-lg">Loading dashboard data...</div>
          </div>
        ) : (
          <div className="space-y-8 animate-fade-in max-w-[1920px] mx-auto px-6 py-6">
            {/* Global Filters */}
            <div className="sticky top-[65px] z-30 bg-background/95 backdrop-blur-sm supports-[backdrop-filter]:bg-background/80 -mx-6 px-6 pt-5 pb-4 border-b shadow-sm">
              <GlobalFilters incidentTypes={incidentTypes} statuses={statuses} />
            </div>
            
            {/* KPI Cards Section - Properly aligned with consistent spacing */}
            <section className="space-y-6">
              {/* Primary KPI Cards */}
              <div>
                <h2 className="text-sm font-semibold text-foreground mb-4 uppercase tracking-wide">Overview</h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
                  <KpiCard 
                    title="Today's Reports" 
                    value={todayCount}
                    icon={<Clock className="h-4 w-4" />} 
                  />
                  <KpiCard 
                    title="Last 7 Days" 
                    value={lastWeekCount} 
                    changeType={parseFloat(weeklyChange) > 0 ? 'increase' : parseFloat(weeklyChange) < 0 ? 'decrease' : 'neutral'}
                    changeValue={`${Math.abs(parseFloat(weeklyChange))}%`}
                    description="vs previous week"
                    icon={<BarChart2 className="h-4 w-4" />} 
                  />
                  <KpiCard 
                    title="Last 30 Days" 
                    value={lastMonthCount}
                    description="total reports"
                    icon={<BarChart2 className="h-4 w-4" />} 
                  />
                  <KpiCard 
                    title="Most Common" 
                    value={mostFrequentType || "N/A"}
                    description="incident type"
                    icon={<BarChart2 className="h-4 w-4" />} 
                  />
                </div>
              </div>

              {/* Status KPI Cards */}
              <div>
                <h2 className="text-sm font-semibold text-foreground mb-4 uppercase tracking-wide">Status Breakdown</h2>
                <StatusKpiCards reports={filteredReports} />
              </div>
            </section>

            {/* Temporal Visualization */}
            <section>
              <h2 className="text-sm font-semibold text-foreground mb-4 uppercase tracking-wide">Crime Trends</h2>
              <div className="w-full h-[500px] transition-smooth">
                <CrimeTrendChart reports={filteredReports} className="h-full" />
              </div>
            </section>

            {/* Map Section */}
            <section>
              <h2 className="text-sm font-semibold text-foreground mb-4 uppercase tracking-wide">Geographic Distribution</h2>
              <div className="w-full h-[500px] transition-smooth">
                <CrimeMap 
                  reports={filteredReports} 
                  onReportSelect={handleReportSelect} 
                />
              </div>
            </section>
            
            {/* Charts Section - Two column grid for smaller visualizations */}
            <section>
              <h2 className="text-sm font-semibold text-foreground mb-4 uppercase tracking-wide">Analytics</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="transition-smooth">
                  <TimeOfDayChart reports={filteredReports} className="h-[400px]" />
                </div>
                <div className="transition-smooth">
                  <IncidentTypeChart reports={filteredReports} className="h-[400px]" />
                </div>
              </div>
            </section>

            {/* Reports Table - Full width */}
            <section>
              <h2 className="text-sm font-semibold text-foreground mb-4 uppercase tracking-wide">All Reports</h2>
              <div className="w-full transition-smooth">
                <ReportsTable 
                  reports={filteredReports} 
                  onReportSelect={handleReportSelect} 
                />
              </div>
            </section>
          </div>
        )}
      </main>
      
      {/* Report Detail Drawer */}
      <ReportDetail 
        report={selectedReport} 
        open={drawerOpen} 
        onOpenChange={setDrawerOpen} 
        onStatusUpdate={handleStatusUpdate}
      />
    </div>
  );
};

// Wrap the dashboard with the FilterProvider
const Dashboard: React.FC = () => {
  return (
    <FilterProvider>
      <DashboardContent />
    </FilterProvider>
  );
};

export default Dashboard;
