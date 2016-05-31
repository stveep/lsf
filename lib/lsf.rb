#require "lsf/version"

class Lsf
  attr_accessor :project, :defaults
  def initialize(project=ENV['LSF_PROJECT'],defaults={	"J" => "myjob", 
							"e" => "lsf_errors.tmp", 
							"o" => "lsf_output.tmp",
							"q" => "normal"
							})
    
    throw "Must supply an LSF project code" unless project
    @project = project 
    @defaults = defaults
  end

  def submit_job(command,options = {})
    @defaults.each do |k,v|
      options[k] = v unless options[k]
    end
    # Reject any options that won't be accepted by bsub
    # Need better ruby
    #options = options.keep_if{|k,v| k.match(/\A[xrNBqmnRJbtioefcWFMDSCkswEL]{1}\z/)}

    cmd = "bsub -P #{@project}"
    options.each do |k, v|
      cmd = cmd + " -#{k} #{v}" 
    end
    cmd = cmd + " #{command}"
    puts cmd
    system(cmd)
  end

end
